module CommandKit
  #
  # Retrieves the current program name.
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
      # The current program name derived from `$0`.
      #
      # @return [String]
      #   The basename of `$0`.
      #
      def program_name
        File.basename($0)
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
