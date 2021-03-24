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
  #     argument :output, type: String,
  #                       desc: 'The output file'
  #     
  #     argument :input, type: Array,
  #                      desc: 'The input file(s)'
  #
  module Arguments
    #
    # Includes {Help} and extends {ClassMethods}.
    #
    # @param [Class] command
    #   The command class which is including {Arguments}.
    #
    def self.included(command)
      command.include Help
      command.extend ClassMethods
    end

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
      #   The argument name.
      #
      # @yield [(arg)]
      #   If a block is given, it will be passed the parsed argument.
      #
      # @yieldparam [Object, nil] arg
      #   The parsed argument.
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
      # @example With a custom block:
      #     argument :bar, desc: "Bar argument" do |bar|
      #       # ...
      #     end
      #
      # @example With a custom type:
      #     argument :bar, type: Integer,
      #                    desc: "Bar argument"
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
      def argument(name,**kwargs,&block)
        arguments[name] = Argument.new(name,**kwargs,&block)
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
    def help
      super if defined?(super)

      unless (arguments = self.class.arguments).empty?
        puts
        puts 'Arguments:'

        self.class.arguments.each_value do |arg|
          puts "    #{arg.usage.ljust(33)}#{arg.desc}"
        end
      end
    end
  end
end
