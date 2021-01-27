module CommandKit
  #
  # Defines a `main` method.
  #
  #     include CommandKit::Main
  #     
  #     def main(*argv)
  #       # ...
  #     end
  #
  module Main
    #
    # Extends {ClassMethods} and prepends {Main::Exit}.
    #
    # @param [Class] command
    #   The command class which is including {Main}.
    #
    def self.included(command)
      command.extend ClassMethods
    end

    #
    # Class-level methods.
    #
    module ClassMethods
      #
      # Starts the command and then exits.
      #
      # @param [Array<String>] argv
      #   The Array of command-line arguments.
      #
      # @param [IO] stdin
      #   `stdin` input stream.
      #
      # @param [IO] stdout
      #   `stdout` output stream.
      #
      # @param [IO] stderr
      #   `stderr` erorr stream.
      #
      def start(argv: ARGV, stdin: $stdin, stdout: $stdout, stderr: $stderr)
        begin
          run(*argv, stdin: stdin, stdout: stdout, stderr: stderr)
        rescue Interrupt
          exit 130
        rescue Errno::EPIPE
          # STDOUT pipe broken
          exit 0
        end
      end

      #
      # @see Main#run
      #
      def run(*argv, stdin: $stdin, stdout: $stdout, stderr: $stderr)
        new().run(*argv)
      end
    end

    #
    # Runs the command instance.
    #
    # @param [Array<String>] argv
    #   The Array of command-line arguments.
    #
    # @param [IO] stdin
    #   `stdin` input stream.
    #
    # @param [IO] stdout
    #   `stdout` output stream.
    #
    # @param [IO] stderr
    #   `stderr` erorr stream.
    #
    # @return [Integer]
    #   The exit status code.
    #
    # @note
    #   If `$stdin`, `$stdout`, `$stderr` will be temporarily overriden before
    #   calling `main` and then restored to their original values.
    #
    def run(*argv, stdin: $stdin, stdout: $stdout, stderr: $stderr)
      orig_stdin  = $stdin
      orig_stdout = $stdout
      orig_stderr = $stderr

      $stdin  = stdin
      $stdout = stdout
      $stderr = stderr

      main(*argv) || 0
    ensure
      $stdin  = orig_stdin
      $stdout = orig_stdout
      $stderr = orig_stderr
    end

    #
    # Place-holder `main` method.
    #
    # @param [Array<String>] argv
    #   The Array of command-line arguments.
    #
    # @return [Integer, nil]
    #   The exit status code.
    #
    # @abstract
    #
    def main(*argv)
    end
  end
end
