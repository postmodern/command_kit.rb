require 'command_kit/inflector'

module CommandKit
  #
  # Defines or derives a command class'es command-name.
  #
  # ## Examples
  #
  #     class MyCmd
  #
  #       include CommandKit::CommandName
  #
  #     end
  #
  #     MyCmd.command_name
  #     # => "my_cmd"
  #
  module CommandName
    #
    # Extends {ClassMethods} and prepends {Prepend}.
    #
    # @param [Class] command
    #   The command class which is including {CommandName}.
    #
    def self.included(command)
      command.extend ClassMethods
      command.prepend Prepend
    end

    #
    # Defines class-level methods.
    #
    module ClassMethods
      #
      # Derives the command name from the class name.
      #
      # @param [String, nil] new_command_name
      #   If given a command name argument, it will override the derived
      #   command name.
      #
      # @return [String]
      #
      def command_name(new_command_name=nil)
        if new_command_name
          @command_name = new_command_name.to_s
        else
          @command_name || Inflector.underscore(name)
        end
      end
    end

    # The commands name.
    #
    # @return [String]
    attr_reader :command_name

    #
    # Methods that are prepended to the including class.
    #
    module Prepend
      #
      # Initializes command_name.
      #
      # @param [String] command_name
      #   Overrides the command name. Defaults to
      #   {ClassMethods#command_name self.class.command_name}.
      #
      def initialize(command_name: self.class.command_name, **kwargs)
        @command_name = command_name

        if defined?(super)
          if self.class.instance_method(:initialize).arity == -1
            super(**kwargs)
          else
            super()
          end
        end
      end
    end
  end
end
