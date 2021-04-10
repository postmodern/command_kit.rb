module CommandKit
  #
  # Defines a `main` method.
  #
  # ## Examples
  #
  #     include CommandKit::Main
  #     
  #     def main(argv=[])
  #       # ...
  #       return 0
  #     end
  #
  module Main
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether {Main}
      # is being included into a class or a module.
      #
      # @param [Class, Module] context
      #   The class or module which is including {Main}.
      #
      def included(context)
        super(context)

        if context.class == Module
          context.extend ModuleMethods
        else
          context.extend ClassMethods
        end
      end
    end

    extend ModuleMethods

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
          exit main(argv, **kwargs)
        rescue Interrupt
          # https://tldp.org/LDP/abs/html/exitcodes.html
          exit 130
        rescue Errno::EPIPE
          # STDOUT pipe broken
          exit 0
        end
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
      # @return [Integer]
      #   The exit status of the command.
      #
      def main(argv=[], **kwargs)
        new(**kwargs).main(argv)
      end
    end

    #
    # Place-holder `main` method, which parses options, before calling {#run}.
    #
    # @param [Array<String>] argv
    #   The Array of command-line arguments.
    #
    # @return [Integer]
    #   The exit status code.
    #
    def main(argv=[])
      run(*argv)
      return 0
    rescue SystemExit => system_exit
      return system_exit.status
    end

    #
    # Place-holder method for command business logic.
    #
    # @param [Array<Object>] args
    #   Additional arguments for the command.
    #   
    # @abstract
    #
    def run(*args)
    end
  end
end
