#!/usr/bin/env ruby

module Generator
  class Parser
    attr_reader :objects
    attr_accessor :filename


    # The way the content is being generated only differs on one char
    # By defining them here, we can use a function (see generate_regex) to create all necessary regex
    TITLE_CHAR = '!'
    CONTENT_CHAR = '-'
    DATE_CHAR = '\+'
    CLOSE_CHAR = '='

    # [\s]* matches leading whitespaces
    # ([^#]*) captures the content in the content group
    # #? matches the comment character
    # (.*) captures the comment in the comment group
    COMMENT = /^[\s]*(?<content>[^#]*)#?(?<comment>.*)$/

    def self.generate_regex(char)
      # #{char} matches the wanted character on the line start
      # [\s]* matches leading whitespaces
      # (.+) captures the valuable content
      /^#{char}(.*)$/
    end

    TITLE = Parser.generate_regex(TITLE_CHAR)
    CONTENT = Parser.generate_regex(CONTENT_CHAR)
    DATE = Parser.generate_regex(DATE_CHAR)
    CLOSE = Parser.generate_regex(CLOSE_CHAR)     # Optional closing character
    ESCAPE = /^.*(\\[#+=!-])+.*$/                 # Captures escaping characters

    # objects: Set of objects that are read from the file
    # current_object: Self explanatory
    # filename: Name of the file to be read
    def initialize(filename)
      @objects = []
      @current_object = {}
      @filename = filename
    end

    # Iterates each line and matches a set of regex to determine its meaning
    def read_file
      File.open(filename, 'r').each_line do |line|
        content = Parser::COMMENT.match(line)[:content]
        objectify( Parser.escape_characters(content) )
      end

      close_object unless @current_object.empty?
      @objects
    end

    # Escapes characters: +=#!- are all used in the filetype, if we want to use them, we need to escape them
    def self.escape_characters(str)
      str.gsub(ESCAPE) { |match| match[1] }
    end

    # Checks the line meaning, pushing it into the current_object if necessary
    def objectify(str)
      case str
      when Parser::TITLE
        push_title(str)
      when Parser::CONTENT
        push_content(str)
      when Parser::DATE
        push_date(str)
      when Parser::CLOSE
        close_object
      end
    end

  private

    # Adds the object to the list and creates a new one
    def close_object
      @objects.push(@current_object)
      @current_object = {}
    end

    # Closes and pushes the current object if it hasn't been done
    # Creates a new one with the title attribute
    def push_title(str)
      close_object unless @current_object.empty?
      @current_object[:title] = str.delete(Parser::TITLE_CHAR).strip
    end

    def push_content(str)
      @current_object[:content] = str.delete(Parser::CONTENT_CHAR).strip
    end

    def push_date(str)
      @current_object[:date] = str.delete(Parser::DATE_CHAR).strip
    end

  end
end

if __FILE__ == $0
  def test_run
    puts "#TestIn\n--------\nEnter a test file:"
    file = STDIN.gets.strip
    puts Generator::Parser.new(file).read_file
  end

  if ARGV[0] == "--test"
    test_run
  end
end
