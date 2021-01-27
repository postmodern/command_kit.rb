# frozen_string_literal: true

require 'command_kit/main'
require 'command_kit/usage'

require 'optparse'

module CommandKit
  #
  # Adds an [OptionParser] to the command class and automatically parses options
  # before calling `main`.
  #
  # [OptionParser]: https://rubydoc.info/stdlib/optparse/OptionParser
  #
  #     include CommandKit::OptParser
  #     
  #     def initialize
  #       @opts.on('-c','--custom','Custom option') do
  #         @custom = true
  #       end
  #     end
  #     
  #     def main(*argv)
  #       if @custom
  #         puts "Custom mode enabled"
  #       end
  #     end
  #
  module Parser
    #
    # Includes {Main}, {Usage}, defines a default usage (`[options]`), and
    # prepends {OptParser::Main}.
    #
    # @param [Class] command
    #   The class including {OptParser}.
    #
    def self.included(command)
      command.include CommandKit::Main
      command.include Usage
      command.usage '[options]'

      command.prepend Parser::Main
    end

    #
    # Overrides the `main` method to automatically parse the options in the
    # given `argv` Array.
    #
    module Main
      #
      # Parses the options and passes any additional non-option arguments
      # to the `super` `main`.
      #
      # @param [Array<String>] argv
      #   The given arguments Array.
      #
      def main(*argv)
        argv = begin
                 @opts.parse(argv)
               rescue OptionParser::InvalidOption,
                      OptionParser::InvalidArgument => error
                 print_error(error.message)
                 exit(1)
               end

        super(*argv)
      end
    end

    # The option parser.
    #
    # @return [OptionParser]
    attr_reader :option_parser

    #
    # The option parser.
    #
    # @return [OptionParser]
    #
    def initialize
      @option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{usage}"

        opts.separator ''
        opts.separator 'Options:'

        opts.on_tail('-h','--help','Print help information') do
          help
          exit(0)
        end
      end

      super
    end

    #
    # Prints the `--help` output.
    #
    def help
      puts option_parser
    end
  end
end
