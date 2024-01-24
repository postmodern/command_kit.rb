require_relative 'inflector'

module CommandKit
  #
  # Defines or derives a command class'es command-name.
  #
  # ## Examples
  #
  # ### Implicit
  #
  #     class MyCmd
  #
  #       include CommandKit::CommandName
  #
  #     end
  #
  #     MyCmd.command_name
  #     # => "my_cmd"
  #
  # ### Explicit
  #
  #     class MyCmd
  #
  #       include CommandKit::CommandName
  #
  #       commnad_name 'foo-cmd'
  #
  #     end
  #
  #     MyCmd.command_name
  #     # => "foo-cmd"
  #
  module CommandName
    #
    # @api private
    #
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether
      # {CommandName} is being included into a class or a module.
      #
      # @param [Class, Module] context
      #   The class or module which is including {CommandName}.
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
      # Derives the command name from the class name.
      #
      # @param [String, nil] new_command_name
      #   If given a command name argument, it will override the derived
      #   command name.
      #
      # @return [String]
      #
      # @api public
      #
      def command_name(new_command_name=nil)
        if new_command_name
          @command_name = new_command_name.to_s
        else
          @command_name || Inflector.underscore(Inflector.demodularize(name))
        end
      end
    end

    # The commands name.
    #
    # @return [String]
    #
    # @api public
    attr_reader :command_name

    #
    # Initializes command_name.
    #
    # @param [String] command_name
    #   Overrides the command name. Defaults to
    #   {ClassMethods#command_name self.class.command_name}.
    #
    # @api public
    #
    def initialize(command_name: self.class.command_name, **kwargs)
      @command_name = command_name

      super(**kwargs)
    end
  end
end
