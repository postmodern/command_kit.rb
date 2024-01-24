# frozen_string_literal: true

require_relative 'help'
require_relative 'command_name'

module CommandKit
  #
  # Allows defining example commands for the command class.
  #
  # ## Examples
  #
  #     include CommandKit::Examples
  #     
  #     examples [
  #       "my_cmd -o output.txt  path/to/file"
  #     ]
  #
  module Examples
    include Help
    include CommandName

    #
    # @api private
    #
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether
      # {Examples} is being included into a class or a module.
      #
      # @param [Class, Module] context
      #   The class or module which is including {Examples}.
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
      # Gets or sets the example commands.
      #
      # @param [Array<String>, String, nil] new_examples
      #   If a String or Array of Strings is given, it will set the class'es
      #   example commands.
      #
      # @return [Array<String>, nil]
      #   The class'es or superclass'es example commands.
      #
      # @example
      #   examples [
      #     "-o output.txt path/to/file"
      #   ]
      #   
      # @api public
      #
      def examples(new_examples=nil)
        if new_examples
          @examples = Array(new_examples)
        else
          @examples || if superclass.kind_of?(ClassMethods)
                         superclass.examples
                       end
        end
      end
    end

    #
    # @see ClassMethods#examples
    #
    # @api semipublic
    #
    def examples
      self.class.examples
    end

    #
    # Prints the command class'es example commands.
    #
    # @api semipublic
    #
    def help_examples
      if (examples = self.examples)
        puts
        puts "Examples:"
        examples.each do |command|
          puts "    #{command_name} #{command}"
        end
      end
    end

    #
    # Calls the superclass'es `#help` method, if it's defined, then calls
    # {#help_examples}.
    #
    # @api public
    #
    def help
      super

      help_examples
    end
  end
end
