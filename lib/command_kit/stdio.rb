module CommandKit
  #
  # Provides access to stdin, stdout, and stderr streams.
  #
  #     class MyCmd
  #       include CommandKit::Stdio
  #
  #       def main
  #       end
  #     end
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
    # Prepends {Initializer}.
    #
    # @param [Class] command
    #   The command class including {Stdio}.
    #
    def self.included(command)
      command.prepend Initializer
    end

    #
    # Defines an {Initializer#initialize #initialize method}.
    #
    module Initializer
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
      def initialize(stdin: $stdin, stdout: $stdout, stderr: $stderr, **kwargs)
        @stdin  = stdin
        @stdout = stdout
        @stderr = stderr

        if self.class.instance_method(:initialize).arity == 0
          super()
        else
          super(**kwargs)
        end
      end
    end

    # The stdin input stream.
    #
    # @return [$stdin, IO]
    attr_reader :stdin

    # The stdout output stream.
    #
    # @return [$stdout, IO]
    attr_reader :stdout

    # The stderr error output stream.
    #
    # @return [$stderr, IO]
    attr_reader :stderr
  end
end
