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
    # Includes {CommandKit::Main}, {Usage}, defines a default usage
    # (`[options]`), and prepends {Prepend}.
    #
    # @param [Class] command
    #   The class including {Parser}.
    #
    def self.included(command)
      command.include CommandKit::Main
      command.include Usage
      command.usage '[options]'

      command.prepend Prepend
    end

    # The option parser.
    #
    # @return [OptionParser]
    attr_reader :option_parser

    #
    # Methods that are prepended to the including class.
    #
    module Prepend
      #
      # Parses the options and passes any additional non-option arguments
      # to the `super` `main`.
      #
      # @param [Array<String>] argv
      #   The given arguments Array.
      #
      def run(argv)
        super(parse_options(argv))
      end

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
    end

    #
    # Parses the given options.
    #
    # @param [Array<String>] argv
    #   The given command-line arguments.
    #
    # @return [Array<String>]
    #   The remaining non-option arguments.
    #
    def parse_options(argv)
      begin
        option_parser.parse(argv)
      rescue OptionParser::InvalidOption => error
        on_invalid_option(error)
      rescue OptionParser::AmbiguousOption => error
        on_ambiguous_option(error)
      rescue OptionParser::InvalidArgument => error
        on_invalid_argument(error)
      rescue OptionParser::MissingArgument => error
        on_missing_argument(error)
      rescue OptionParser::NeedlessArgument => error
        on_needless_argument(error)
      rescue OptionParser::AmbiguousArgument => error
        on_ambiguous_argument(error)
      end
    end

    #
    # Prints an option parsing error.
    #
    # @param [OptionParser::ParseError] error
    #   The error from `OptionParser`.
    #
    def on_parse_error(error)
      print_error(error.message)
      exit(1)
    end

    #
    # Place-holder method for handling `OptionParser::InvalidOption` exceptions.
    #
    # @param [OptionParser::InvalidOption] error
    #
    # @see on_parse_error
    #
    def on_invalid_option(error)
      on_parse_error(error)
    end

    #
    # Place-holder method for handling `OptionParser::AmbiguousOption`
    # exceptions.
    #
    # @param [OptionParser::AmbiguousOption] error
    #
    # @see on_parse_error
    #
    def on_ambiguous_option(error)
      on_parse_error(error)
    end

    #
    # Place-holder method for handling `OptionParser::InvalidArgument`
    # exceptions.
    #
    # @param [OptionParser::InvalidArgument] error
    #
    # @see on_parse_error
    #
    def on_invalid_argument(error)
      on_parse_error(error)
    end

    #
    # Place-holder method for handling `OptionParser::MissingArgument`
    # exceptions.
    #
    # @param [OptionParser::MissingArgument] error
    #
    # @see on_parse_error
    #
    def on_missing_argument(error)
      on_parse_error(error)
    end

    #
    # Place-holder method for handling `OptionParser::NeedlessArgument`
    # exceptions.
    #
    # @param [OptionParser::NeedlessArgument] error
    #
    # @see on_parse_error
    #
    def on_needless_argument(error)
      on_parse_error(error)
    end

    #
    # Place-holder method for handling `OptionParser::AmbiguousArgument`
    # exceptions.
    #
    # @param [OptionParser::AmbiguousArgument] error
    #
    # @see on_parse_error
    #
    def on_ambiguous_argument(error)
      on_parse_error(error)
    end

    #
    # Prints the `--help` output.
    #
    def help
      puts option_parser
    end
  end
end
