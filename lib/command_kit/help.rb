module CommandKit
  #
  # Defines a place-holder {Help#help help} method.
  #
  # ## Examples
  #
  #     class MyCmd
  #       include CommandKit::Help
  #     
  #       def help
  #         puts "..."
  #       end
  #     end
  #     
  #     MyCmd.help
  #
  module Help
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether {Help}
      # is being included into a class or a module.
      #
      # @param [Class, Module] context
      #   The class or module which is extending {ClassMethods}.
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

    module ClassMethods
      #
      # Prints `--help` information.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for `#initialize`.
      #
      # @see Help#help
      #
      def help(**kwargs)
        new(**kwargs).help
      end
    end

    #
    # Prints `--help` information.
    #
    # @abstract
    #
    def help
      super if defined?(super)
    end
  end
end
