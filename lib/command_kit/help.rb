module CommandKit
  #
  # Defines a place-holder {Help#help help} method.
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
    end
  end
end
