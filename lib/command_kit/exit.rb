require 'command_kit/main'

module CommandKit
  #
  # Catches any calls to `exit` within `main` and returns the exit status code
  # instead.
  #
  # ## Examples
  #
  #     include CommandKit::Exit
  #     
  #     def main(*argv)
  #       # ...
  #     
  #       exit(0)
  #     end
  #
  module Exit
    #
    # Prepends {Catcher}.
    #
    # @param [Class] command
    #   The command class which is including {Exit}.
    #
    def self.included(command)
      command.include Main
    end

    #
    # Exits the `main()` method with the given exit status.
    #
    # @param [Integer] status
    #   The given exit status.
    #
    # @note
    #   Throws `:exit` with the  status code to prevent the command from
    #   exitting the ruby process.
    #
    def exit(status=0)
      raise(SystemExit.new(status))
    end

    #
    # Overrides abort to call our {#exit} instead.
    #
    # @param [String, nil] message
    #   The optional abort message.
    #
    def abort(message=nil)
      $stderr.puts(message) if message
      exit 1
    end
  end
end
