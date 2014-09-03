#!/usr/bin/env ruby

# Export a given set of objects into an html page
module Generator
  class Export
    require 'slim'
    require_relative 'boot_config.rb'

    # object: Objects to be exported
    # target: Target html filename to be writen.
    def initialize(objects, target)
      @objects = objects
      @target = target
    end

    def export
      File.open(@target, 'w') do |f|
        to_html = Slim::Template.new(BootConfig::TEMPLATE, :pretty => true,
                                        :format => :html5).render(Hash, objects: @objects)
        f.write(to_html)
      end
    end
  end
end
