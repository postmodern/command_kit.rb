require 'command_kit/help'
require 'command_kit/arguments/argument'

module CommandKit
  #
  # Provides a thin DSL for defining arguments as attributes.
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
        @arguments ||= if superclass.include?(ClassMethods)
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
      def argument(name,**kwargs,&block)
        arguments[name] = Argument.new(name,**kwargs,&block)
      end
    end

    #
    # Prints any defined arguments, along with the usual `--help` information.
    #
    def help
      super

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
