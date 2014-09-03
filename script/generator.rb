#!/usr/bin/env ruby

module Generator
  class Base
    require_relative 'export.rb'
    require_relative 'parser.rb'
    require_relative 'boot_config.rb'

    def initialize(target)
      @target = target
    end

    def generate
      objects = Generator::Parser.new(@target).read_file
      Generator::Export.new(objects, BootConfig::TARGET).export
    end
  end
end
