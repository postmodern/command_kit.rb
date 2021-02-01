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
    #
    # Extends {ClassMethods}.
    #
    # @param [Class] base
    #   The command class which is extending {ClassMethods}.
    #
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      #
      # Prints `--help` information.
      #
      # @see Help#help
      #
      def help
        new().help
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
