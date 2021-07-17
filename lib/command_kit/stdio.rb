module CommandKit
  #
  # Provides access to stdin, stdout, and stderr streams.
  #
  # ## Examples
  #
  #     class MyCmd
  #       include CommandKit::Stdio
  #
  #       def main
  #       end
  #     end
  #
  # ## Testing
  #
  # Can be initialized with custom stdin, stdout, and stderr streams for testing
  # purposes.
  #
  #     stdin  = StringIO.new
  #     stdout = StringIO.new
  #     stderr = StringIO.new
  #     MyCmd.new(stdin: stdin, stdout: stdout, stderr: stderr)
  #
  module Stdio
    #
    # Initializes {#stdin}, {#stdout}, and {#stderr}.
    #
    # @param [IO] stdin
    #   The stdin input stream. Defaults to `$stdin`.
    #
    # @param [IO] stdout
    #   The stdout output stream. Defaults to `$stdout`.
    #
    # @param [IO] stderr
    #   The stderr error output stream. Defaults to `$stderr`.
    #
    # @api public
    #
    def initialize(stdin: nil, stdout: nil, stderr: nil, **kwargs)
      @stdin  = stdin
      @stdout = stdout
      @stderr = stderr

      super(**kwargs)
    end

    #
    # Returns the stdin input stream.
    #
    # @return [$stdin, IO]
    #   The initialized `@stdin` value or `$stdin`.
    #
    # @api public
    #
    def stdin
      @stdin || $stdin
    end

    #
    # Returns the stdout output stream.
    #
    # @return [$stdout, IO]
    #   The initialized `@stdout` value or `$stdout`.
    #
    # @api public
    #
    def stdout
      @stdout || $stdout
    end

    #
    # Returns the stderr error output stream.
    #
    # @return [$stderr, IO]
    #   The initialized `@stderr` value or `$stderr`.
    #
    # @api public
    #
    def stderr
      @stderr || $stderr
    end

    #
    # Calls `stdin.gets`.
    #
    # @api public
    #
    def gets(*arguments)
      stdin.gets(*arguments)
    end

    #
    # Calls `stdin.readline`.
    #
    # @api public
    #
    def readline(*arguments)
      stdin.readline(*arguments)
    end

    #
    # Calls `stdin.readlines`.
    #
    # @api public
    #
    def readlines(*arguments)
      stdin.readlines(*arguments)
    end

    # NOTE: intentionally do not override `Kenrel#p` or `Kernel#pp` to not
    # hijack echo-debugging.

    #
    # Calls `stdout.putc`.
    #
    # @api public
    #
    def putc(*arguments)
      stdout.putc(*arguments)
    end

    #
    # Calls `stdout.puts`.
    #
    # @api public
    #
    def puts(*arguments)
      stdout.puts(*arguments)
    end

    #
    # Calls `stdout.print`.
    #
    # @api public
    #
    def print(*arguments)
      stdout.print(*arguments)
    end

    #
    # Calls `stdout.printf`.
    #
    # @api public
    #
    def printf(*arguments)
      stdout.printf(*arguments)
    end

    #
    # Overrides `Kernel.abort` to print to {#stderr}.
    #
    # @param [String, nil] message
    #   The optional abort message.
    #
    # @api public
    #
    def abort(message=nil)
      stderr.puts(message) if message
      exit(1)
    end
  end
end
