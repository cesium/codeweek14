#!/usr/bin/env ruby

class Bootstrap
	require 'rbconfig'
	require_relative 'boot_config.rb'
	require_relative 'generator.rb'

	# Configure and install dependencies
	def self.install
		puts "Dependent gems: #{BootConfig::DEPENDS.join(', ')}. Checking availability..."
		BootConfig::DEPENDS.each do |gem|
			if Bootstrap.has_gem?(gem)
				puts "#{gem}: install available."
			else
				`gem install #{gem}`
				puts "Installed #{gem}"
			end
		end

		`bourbon install` unless File.directory?('scss/bourbon')
	end

	# Generate the HTML index
	def self.generate(target)
		Generator::Base.new(target).generate
	end

	def self.deploy
		current_branch = `git branch`.split("\n").select { |branch| branch[0] == '*' }.first.delete('*').strip
		`git checkout gh-pages; git rebase #{current_branch}`
		`git push; git checkout #{current_branch}`
	end

	def self.run(args)
		# Generates the correct arguments, if any, and runs the script
		method = args.length > 1 ? "#{args[0]}('#{args[1..-1].join(' ')}')" : args.join(' ')
		eval "Bootstrap.#{method}"
	end

	# Update changed sass files
	def self.sass
		# Selects changed files using git
		changed_sass = `git diff --name-only`.split("\n").select { |file| file.match(/scss\/.+/) }
		# Generates the corresponding css file with the same name
		changed_sass.each { |file| `sass #{file} > css/#{file.split('/')[-1].gsub('.scss', '.css') }` }
	end

	# Generates HTML index and updates sass files
  def self.gen_sass(target)
    Bootstrap.generate(target)
    Bootstrap.sass
  end

private
	def self.has_gem?(name)
		Gem::Specification::find_all_by_name(name).any?
	end
end


if __FILE__ == $0

	# Checks if the current directory is the root
	if Dir.pwd.split('/')[-1] != BootConfig::ROOT
		puts "\n### Error: Please run this script from the project directory"
	else
		Bootstrap.run(ARGV)
	end
end