require_relative 'help'

module CommandKit
  #
  # Allows adding a description to a command's class.
  #
  # ## Examples
  #
  #     include CommandKit::Description
  #
  #     description "Does things and stuff"
  #
  module Description
    include Help

    #
    # @api private
    #
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether
      # {Description} is being included into a class or a module.
      #
      # @param [Class, Module] context
      #   The class or module which is including {Description}.
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
    # Defines class-level methods.
    #
    module ClassMethods
      #
      # Gets or sets the description string.
      #
      # @param [String, nil] new_description
      #   If a String is given, the class'es description will be set.
      #
      # @return [String, nil]
      #   The class'es or superclass'es description.
      #
      # @example
      #   description "Does things and stuff"
      #
      # @api public
      #
      def description(new_description=nil)
        if new_description
          @description = new_description
        else
          @description || if superclass.kind_of?(ClassMethods)
                            superclass.description
                          end
        end
      end
    end

    #
    # @see ClassMethods#description
    #
    # @api semipublic
    #
    def description
      self.class.description
    end

    #
    # Prints the {ClassMethods#description description}, if set.
    #
    # @api semipublic
    #
    def help_description
      if (description = self.description)
        puts
        puts description
      end
    end

    #
    # Calls the superclass'es `#help` method, if it's defined, then calls
    # {#help_description}.
    #
    # @api public
    #
    def help
      super

      help_description
    end
  end
end
