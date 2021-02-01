require 'command_kit/main'

module CommandKit
  #
  # Catches any calls to `exit` within `main` and returns the exit status code
  # instead.
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
      command.prepend Catcher
    end

    module Catcher
      #
      # Calls the `super` `#run` method but catches any `exit()` calls,
      # returning the exit status instead.
      #
      # @param [Array<String>] argv
      #   Arguments for `#main`.
      #
      # @return [Integer]
      #   The exit status. Defaults to `0`.
      #
      def run(argv)
        catch(:exit) do
          super(argv)
          0
        end
      end

      #
      # Calls the `super` `#main` method but catches any `exit()` calls,
      # returning the exit status instead.
      #
      # @param [Array<String>] argv
      #   Arguments for `#main`.
      #
      # @return [Integer]
      #   The exit status. Defaults to `0`.
      #
      def main(*argv)
        catch(:exit) do
          super(*argv)
          0
        end
      end
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
      throw :exit, status
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
