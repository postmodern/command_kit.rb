module CommandKit
  #
  # Retrieves the current program name (`$PROGRAM_NAME`).
  #
  module ProgramName
    #
    # Extends {ClassMethods}.
    #
    # @param [Class] command
    #   The command class which is including {ProgramName}.
    #
    def self.included(command)
      command.extend ClassMethods
    end

    #
    # Class-level methods.
    #
    module ClassMethods
      #
      # The current program name (`$PROGRAM_NAME`).
      #
      # @return [String]
      #   `$PROGRAM_NAME`
      #
      def program_name
        $PROGRAM_NAME
      end
    end

    #
    # @see ClassMethods#program_name
    #
    def program_name
      self.class.program_name
    end
  end
end
