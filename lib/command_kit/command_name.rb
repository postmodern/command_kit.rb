require 'command_kit/inflector'

module CommandKit
  #
  # Defines or derives a command class'es command-name.
  #
  module CommandName
    #
    # Extends {ClassMethods}.
    #
    # @param [Class] command
    #   The command class which is including {CommandName}.
    #
    def self.included(command)
      command.extend ClassMethods
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
          @command_name = new_command_name
        else
          @command_anme || Inflector.underscore(name)
        end
      end
    end

    #
    # @see ClassMethods#command_name
    #
    def command_name
      self.class.command_name
    end
  end
end
