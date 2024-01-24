require_relative '../commands'
require_relative 'subcommand'
require_relative '../inflector'

module CommandKit
  module Commands
    #
    # Adds a catch-all that attempts to load missing commands from a
    # directory/namespace.
    #
    # ## Examples
    #
    #     module Foo
    #       class CLI
    #     
    #         include CommandKit::Commands
    #         include CommandKit::Commands::AutoRequire.new(
    #           dir:       'foo/bar/commands',
    #           namespace: 'Foo::CLI::Commands'
    #         )
    #     
    #       end
    #     end
    #
    class AutoRequire < Module

      # The directory to attempt to require command files within.
      #
      # @return [String]
      #
      # @api private
      attr_reader :dir

      # The namespace to lookup command classes within.
      #
      # @return [String]
      #
      # @api private
      attr_reader :namespace

      #
      # Initializes.
      #
      # @param [String] dir
      #   The directory to require commands from.
      #
      # @param [String] namespace
      #   The namespace to search for command classes in.
      #
      # @api public
      #
      def initialize(dir: , namespace: )
        @dir       = dir
        @namespace = namespace
      end

      #
      # Returns the path for the given command name.
      #
      # @param [String] name
      #   The given command name.
      #
      # @return [String]
      #   The path to the file that should contain the command.
      #
      # @api private
      #
      def join(name)
        File.join(@dir,name)
      end

      #
      # Requires a file within the {#dir}.
      #
      # @param [String] file_name
      #
      # @return [Boolean]
      #
      # @raise [LoadError]
      #
      # @api private
      #
      def require(file_name)
        super(join(file_name))
      end

      #
      # Resolves the constant for the command class within the {#namespace}.
      #
      # @param [String] constant
      #   The constant name.
      #
      # @return [Class]
      #   The command class.
      #
      # @raise [NameError]
      #   The command class could not be found within the {#namespace}.
      #
      # @api private
      #
      def const_get(constant)
        Object.const_get("::#{@namespace}::#{constant}",false)
      end

      #
      # Attempts to load the command from the {#dir} and {#namespace}.
      #
      # @param [String] command_name
      #   The given command name.
      #
      # @return [Class, nil]
      #   The command's class, or `nil` if the command cannot be loaded from
      #   {#dir} or found within {#namespace}.
      #
      # @api private
      #
      def command(command_name)
        file_name = Inflector.underscore(command_name)

        begin
          require(file_name)
        rescue LoadError
          return
        end

        constant = Inflector.camelize(file_name)

        begin
          const_get(constant)
        rescue NameError
          return
        end
      end

      #
      # Includes {Commands} and adds a default proc to
      # {Commands::ClassMethods#commands .commands}.
      #
      # @param [Class] command
      #   The command class including {AutoRequire}.
      #
      # @api private
      #
      def included(command)
        command.include Commands
        command.commands.default_proc = ->(hash,key) {
          hash[key] = if (command_class = command(key))
                        Commands::Subcommand.new(command_class)
                      end
        }
      end
    end
  end
end
