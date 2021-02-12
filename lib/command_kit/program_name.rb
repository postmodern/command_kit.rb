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
      # List of `$PROGRAM_NAME`s that should be ignored.
      IGNORED_PROGRAM_NAMES = [
        '-e',   # ruby -e "..."
        'irb',  # running in irb
        'rspec' # running in rspec
      ]

      #
      # The current program name (`$PROGRAM_NAME`).
      #
      # @return [String, nil]
      #   The `$PROGRAM_NAME` or `nil` if the `$PROGRAM_NAME` is `-e`, `irb`,
      #   or `rspec`.
      #
      def program_name
        $PROGRAM_NAME unless IGNORED_PROGRAM_NAMES.include?($PROGRAM_NAME)
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
