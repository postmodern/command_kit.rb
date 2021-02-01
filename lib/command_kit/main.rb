module CommandKit
  #
  # Defines a `main` method.
  #
  # ## Examples
  #
  #     include CommandKit::Main
  #     
  #     def main(*argv)
  #       # ...
  #     end
  #
  module Main
    #
    # Extends {ClassMethods} and prepends {Exit}.
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
      def start(argv=ARGV, **kwargs)
        begin
          exit run(argv, **kwargs)
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
      # @param [Array<String>] argv
      #   The Array of command-line arguments.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments to initialize the command class with.
      #
      def run(argv=[], **kwargs)
        new(**kwargs).run(argv)
      end

      #
      # Initializes the command class with the given keyword arguments, then
      # calls {Main#main main} with the given `argv`.
      #
      # @param [Array<String>] argv
      #   The Array of command-line arguments.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments to initialize the command class with.
      #
      def main(*argv, **kwargs)
        new(**kwargs).main(*argv)
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
    def run(argv=[])
      main(*argv) || 0
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
