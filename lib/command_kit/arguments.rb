# frozen_string_literal: true

require 'command_kit/main'
require 'command_kit/help'
require 'command_kit/arguments/argument'

module CommandKit
  #
  # Provides a thin DSL for defining arguments as attributes.
  #
  # ## Examples
  #
  #     include CommandKit::Arguments
  #     
  #     argument :output, desc: 'The output file'
  #     
  #     argument :input, desc: 'The input file(s)'
  #     
  #     def run(output,input)
  #     end
  #
  # ### Optional Arguments
  #
  #     argument :dir, required: false,
  #                    desc:     'Can be omitted'
  #
  #     def run(dir=nil)
  #     end
  #
  # ### Repeating Arguments
  #
  #     argument :files, repeats: true,
  #                      desc:    'Can be repeated one or more times'
  #
  #     def run(*files)
  #     end
  #
  # ### Optional Repeating Arguments
  #
  #     argument :files, required: true,
  #                      repeats:  true,
  #                      desc:     'Can be repeated one or more times'
  #
  #     def run(*files)
  #     end
  #
  module Arguments
    include Main
    include Help

    #
    # @api private
    #
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether
      # {Arguments} is being included into a class or module.
      #
      # @param [Class, Module] context
      #   The class or module which is including {Arguments}.
      #
      def included(context)
        super(context)

        if context.class == Module
          context.extend ModuleMethods
        else
          context.extend ClassMethods
        end
      end
    end

    extend ModuleMethods

    #
    # Defines class-level methods.
    #
    module ClassMethods
      #
      # All defined arguments for the class.
      #
      # @return [Hash{Symbol => Argument}]
      #   The defined argument for the class and it's superclass.
      #
      # @api semipublic
      #
      def arguments
        @arguments ||= if superclass.kind_of?(ClassMethods)
                         superclass.arguments.dup
                       else
                         {}
                       end
      end

      #
      # Defines an argument for the class.
      #
      # @param [Symbol] name
      #   The name of the argument.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Keyword arguments.
      #
      # @option kwargs [String, nil] usage
      #   The usage string for the argument. Defaults to the argument's name.
      #
      # @option kwargs [Boolean] required
      #   Specifies whether the argument is required or optional.
      #
      # @option kwargs [Boolean] repeats
      #   Specifies whether the argument can be repeated multiple times.
      #
      # @option kwargs [String] desc
      #   The description for the argument.
      #
      # @return [Argument]
      #   The newly defined argument.
      #
      # @example Define an argument:
      #     argument :bar, desc: "Bar argument"
      #
      # @example With a custom usage string:
      #     option :bar, usage: 'BAR',
      #                  desc: "Bar argument"
      #
      # @example With a custom type:
      #     argument :bar, desc: "Bar argument"
      #
      # @example With a default value:
      #     argument :bar, default: "bar.txt",
      #                    desc: "Bar argument"
      #
      # @example An optional argument:
      #     argument :bar, required: true,
      #                    desc: "Bar argument"
      #
      # @example A repeating argument:
      #     argument :bar, repeats: true,
      #                    desc: "Bar argument"
      #
      # @api public
      #
      def argument(name,**kwargs)
        arguments[name] = Argument.new(name,**kwargs)
      end
    end

    #
    # Checks the minimum/maximum number of arguments, then calls the
    # superclass'es `#main`.
    #
    # @param [Array<String>] argv
    #   The arguments passed to the program.
    #
    # @return [Integer]
    #   The exit status code. If too few or too many arguments are given, then
    #   an error message is printed and `1` is returned.
    #
    # @api public
    #
    def main(argv=[])
      required_args   = self.class.arguments.each_value.count(&:required?)
      optional_args   = self.class.arguments.each_value.count(&:optional?)
      has_repeats_arg = self.class.arguments.each_value.any?(&:repeats?)

      if argv.length < required_args
        print_error("insufficient number of arguments.")
        help_usage
        return 1
      elsif argv.length > (required_args + optional_args) && !has_repeats_arg
        print_error("too many arguments given")
        help_usage
        return 1
      end

      super(argv)
    end

    #
    # Prints any defined arguments, along with the usual `--help` information.
    #
    # @api semipublic
    #
    def help_arguments
      unless (arguments = self.class.arguments).empty?
        puts
        puts 'Arguments:'

        arguments.each_value do |arg|
          puts "    #{arg.usage.ljust(33)}#{arg.desc}"
        end
      end
    end

    #
    # Calls the superclass'es `#help` method, if it's defined, then calls
    # {#help_arguments}.
    #
    # @api public
    #
    def help
      super

      help_arguments
    end
  end
end
