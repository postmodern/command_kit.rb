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
      def start(argv=ARGV, **kwargs)
        begin
          exit run(argv, **kwargs)
        rescue Interrupt
          # https://tldp.org/LDP/abs/html/exitcodes.html
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
      # @return [Integer]
      #   The exit status of the command.
      #
      def run(argv=[], **kwargs)
        main(*argv, **kwargs)
        0
      rescue SystemExit => system_exit
        system_exit.status
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
