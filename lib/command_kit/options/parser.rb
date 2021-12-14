# frozen_string_literal: true

require 'command_kit/main'
require 'command_kit/usage'
require 'command_kit/printing'

require 'optparse'

module CommandKit
  module Options
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
      include Usage
      include Main
      include Printing

      #
      # @api private
      #
      module ModuleMethods
        #
        # Sets {CommandKit::Usage::ClassMethods#usage .usage} or extends
        # {ModuleMethods}, depending on whether {Options::Parser} is being
        # included into a class or a module.
        #
        # @param [Class, Module] context
        #   The class or module including {Parser}.
        #
        def included(context)
          super

          if context.class == Module
            context.extend ModuleMethods
          else
            context.usage '[options]'
          end
        end
      end

      extend ModuleMethods

      # The option parser.
      #
      # @return [OptionParser]
      #
      # @api semipublic
      attr_reader :option_parser

      #
      # The option parser.
      #
      # @return [OptionParser]
      #
      # @api public
      #
      def initialize(**kwargs)
        super(**kwargs)

        @option_parser = OptionParser.new do |opts|
          opts.banner = "Usage: #{usage}"

          opts.on_tail('-h','--help','Print help information') do
            help
            exit(0)
          end
        end
      end

      #
      # Parses the options and passes any additional non-option arguments
      # to the superclass'es `#main` method.
      #
      # @param [Array<String>] argv
      #   The given arguments Array.
      #
      # @return [Integer]
      #   The exit status code.
      #
      # @api public
      #
      def main(argv=[])
        super(parse_options(argv))
      rescue SystemExit => system_exit
        system_exit.status
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
      # @api semipublic
      #
      def parse_options(argv)
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
      rescue OptionParser::ParseError => error
        on_parse_error(error)
      end

      #
      # Prints an option parsing error.
      #
      # @param [OptionParser::ParseError] error
      #   The error from `OptionParser`.
      #
      # @api semipublic
      #
      def on_parse_error(error)
        print_error(error.message)
        stderr.puts("Try '#{command_name} --help' for more information.")
        exit(1)
      end

      #
      # Place-holder method for handling `OptionParser::InvalidOption` exceptions.
      #
      # @param [OptionParser::InvalidOption] error
      #
      # @see on_parse_error
      #
      # @api semipublic
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
      # @api semipublic
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
      # @api semipublic
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
      # @api semipublic
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
      # @api semipublic
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
      # @api semipublic
      #
      def on_ambiguous_argument(error)
        on_parse_error(error)
      end

      #
      # Prints the `--help` output.
      #
      # @api semipublic
      #
      def help_options
        puts option_parser
      end

      #
      # @see #help_options
      #
      # @api public
      #
      def help
        help_options
      end
    end
  end
end
