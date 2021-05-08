# frozen_string_literal: true

require 'command_kit/commands'
require 'command_kit/commands/auto_load/subcommand'
require 'command_kit/inflector'

module CommandKit
  module Commands
    #
    # Provides lazy-loading access to a directory / module namespace of
    # command classes.
    #
    # ## Examples
    #
    #     class CLI
    #     
    #       include CommandKit::Commands::AutoLoad.new(
    #         dir:       "#{__dir__}/cli/commands",
    #         namespace: 'CLI::Commands'
    #       )
    #     
    #     end
    #
    # ### Explicit Mapping
    #
    #     class CLI
    #     
    #       include CommandKit::Commands::AutoLoad.new(
    #         dir:       "#{__dir__}/cli/commands",
    #         namespace: 'CLI::Commands'
    #       ) { |autoload|
    #         autoload.command 'foo', 'Foo', 'foo.rb', summary: 'Foo command'
    #         autoload.command 'bar', 'Bar', 'bar.rb', summary: 'Bar command'
    #       }
    #     
    #     end
    #
    class AutoLoad < Module

      # The auto-load subcommands.
      #
      # @return [Hash{String => Subcommand}]
      attr_reader :commands

      # The path to the directory containing the command files.
      #
      # @return [String]
      attr_reader :dir

      # The namespace that the will contain the command classes.
      #
      # @return [String]
      attr_reader :namespace

      #
      # Initializes the namespace.
      #
      # @param [String] dir
      #   The path to the directory containing the command files.
      #
      # @param [Module, Class, String] namespace
      #   The namespace constant that contains the command classes.
      #
      # @yield [self]
      #   If a block is given, it will be used to explicitly map the files
      #   within {#dir} as commands.
      #
      def initialize(dir: , namespace: )
        @commands  = {}

        @dir       = dir
        @namespace = namespace

        if block_given?
          yield self
        else
          files.each do |path|
            base_name    = File.basename(path)
            file_name    = base_name.chomp('.rb')
            command_name = Inflector.dasherize(file_name)
            class_name   = Inflector.camelize(file_name)

            command command_name, class_name, base_name
          end
        end
      end

      #
      # Defines an auto-loaded command mapping.
      #
      # @param [#to_s] name
      #   The name of the command.
      #
      # @param [String] constant
      #   The constant name of the command class.
      #
      # @param [String] file
      #   The file name of the command class.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Keyword arguments.
      #
      # @option kwargs [String, nil] summary
      #   An optional summary for the command.
      #
      # @option kwargs [Array<String>] aliases
      #   Optional alias names for the subcommand.
      #
      def command(name, constant, file, **kwargs)
        @commands[name.to_s] = Subcommand.new(
          "#{@namespace}::#{constant}",
          join(file),
          **kwargs
        )
      end

      #
      # Joins a relative path with {#dir}.
      #
      # @param [String] path
      #   The relative path.
      #
      # @return [String]
      #   The joined absolute path.
      #
      def join(path)
        File.join(@dir,path)
      end

      #
      # Returns the files within given directory.
      #
      # @return [Array<String>]
      #   The paths to the `.rb` files in the directory.
      #
      def files
        Dir.glob(join('*.rb'))
      end

      #
      # Includes {Commands} and registers all files within the namespace
      # as lazy-loaded subcommands.
      #
      # @param [Class] command
      #   The command class including {AutoLoad}.
      #
      def included(command)
        command.include Commands
        command.commands.merge!(@commands)
      end
    end
  end
end
