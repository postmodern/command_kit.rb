require 'command_kit/help'

module CommandKit
  #
  # Allows adding a description to a command's class.
  #
  #     include CommandKit::Description
  #
  #     description "Does things and stuff"
  #
  module Description
    #
    # Includes {Help} and extends {ClassMethods}.
    #
    # @param [Class] command
    #   The command class which is including {Description}.
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
      # Gets or sets the description string.
      #
      # @param [String, nil] new_description
      #   If a String is given, the class'es description will be set.
      #
      # @return [String, nil]
      #   The class'es or superclass'es description.
      #
      # @example
      #   description "Does things and stuff"
      #
      def description(new_description=nil)
        if new_description
          @description = new_description
        else
          @description || (superclass.description if superclass.kind_of?(ClassMethods))
        end
      end
    end

    #
    # @see ClassMethods#description
    #
    def description
      self.class.description
    end

    #
    # Prints the {ClassMethods#description description}, if set.
    #
    def help
      super if defined?(super)

      if (description = self.description)
        puts
        puts description
      end
    end
  end
end
