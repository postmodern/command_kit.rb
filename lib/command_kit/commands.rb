# frozen_string_literal: true

require 'command_kit/commands/subcommand'
require 'command_kit/commands/parent_command'
require 'command_kit/commands/help'
require 'command_kit/command_name'
require 'command_kit/usage'
require 'command_kit/options'
require 'command_kit/stdio'
require 'command_kit/env'

module CommandKit
  #
  # Adds sub-commands to a command.
  #
  # ## Examples
  #
  #     class CLI
  #     
  #       include CommandKit::Commands
  #     
  #       command_name :foo
  #     
  #       class Foo < CommandKit::Command
  #         # ...
  #       end
  #     
  #       class FooBar < CommandKit::Command
  #         # ...
  #       end
  #     
  #       command Foo
  #       command 'foo-bar', FooBar
  #     
  #     end
  #
  module Commands
    include CommandName
    include Usage
    include Options
    include Stdio
    include Env

    #
    # @api private
    #
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether
      # {Commands} is being included into a class or a module.
      #
      # @param [Class, Module] context
      #   The class or module which is including {Commands}.
      #
      def included(context)
        super(context)

        if context.class == Module
          context.extend ModuleMethods
        else
          context.usage "[options] [COMMAND [ARGS...]]"
          context.argument :command, required: false,
                                     desc: 'The command name to run'

          context.argument :args, required: false,
                                  repeats: true,
                                  desc: 'Additional arguments for the command'

          context.extend ClassMethods
          context.command Help
        end
      end
    end

    extend ModuleMethods

    #
    # Class-level methods.
    #
    module ClassMethods
      #
      # The registered sub-commands.
      #
      # @return [Hash{String => Subcommand}]
      #   The Hash of sub-command names and command classes.
      #
      # @api semipublic
      # 
      def commands
        @commands ||= if superclass.kind_of?(ClassMethods)
                        superclass.commands.dup
                      else
                        {}
                      end
      end

      #
      # The registered command aliases.
      #
      # @return [Hash{String => String}]
      #   The Hash of command aliases to primary command names.
      # 
      # @api semipublic
      #
      def command_aliases
        @command_aliases ||= if superclass.kind_of?(ClassMethods)
                               superclass.command_aliases.dup
                             else
                               {}
                             end
      end

      #
      # Mounts a command as a sub-command.
      #
      # @param [#to_s] name
      #   The optional name to mount the command as. Defaults to the command's
      #   {CommandName::ClassMethods#command_name command_name}.
      #
      # @param [Class#main] command_class
      #   The sub-command class.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Keyword arguments.
      #
      # @option kwargs [String, nil] summary
      #   A short summary for the subcommand. Defaults to the first sentence
      #   of the command.
      #
      # @option kwags [Array<String>] aliases
      #   Optional alias names for the subcommand.
      #
      # @return [Subcommand]
      #   The registered sub-command class.
      #
      # @example
      #   command Foo
      #
      # @example
      #   command 'foo-bar', FooBar
      #
      # @api public
      #
      def command(name=nil, command_class, **kwargs)
        name = if name then name.to_s
               else         command_class.command_name
               end

        subcommand = Subcommand.new(command_class,**kwargs)
        commands[name] = subcommand

        subcommand.aliases.each do |alias_name|
          command_aliases[alias_name] = name
        end

        return subcommand
      end

      #
      # Gets the command.
      #
      # @param [String] name
      #   The command name.
      #
      # @return [Class#main, nil]
      #   The command class or `nil` if no command could be found.
      #
      # @api private
      #
      def get_command(name)
        name = name.to_s
        name = command_aliases.fetch(name,name)

        if (subcommand = commands[name])
          subcommand.command
        end
      end
    end

    #
    # Initializes the command.
    #
    # @note Adds a special rule to the {Options#option_parser #option_parser} to
    # stop parsing options when the first non-option is encountered.
    #
    # @api public
    #
    def initialize(**kwargs)
      super(**kwargs)

      @option_parser.on(/^[^-].*$/) do |command|
        OptionParser.terminate(command)
      end
    end

    #
    # Looks up the given command name and initializes a subcommand.
    #
    # @param [#to_s] name
    #   The given command name.
    #
    # @return [Object#main, nil]
    #   The initialized subcommand.
    #
    # @api private
    #
    def command(name)
      unless (command_class = self.class.get_command(name))
        return
      end

      kwargs = {}

      if command_class.include?(ParentCommand)
        kwargs[:parent_command] = self
      end

      if command_class.include?(CommandName)
        kwargs[:command_name] = "#{command_name} #{command_class.command_name}"
      end

      if command_class.include?(Stdio)
        kwargs[:stdin]  = stdin
        kwargs[:stdout] = stdout
        kwargs[:stderr] = stderr
      end

      if command_class.include?(Env)
        kwargs[:env] = if env.eql?(ENV) then env.to_h
                       else                  env.dup
                       end
      end

      if command_class.include?(Options)
        kwargs[:options] = options.dup
      end

      return command_class.new(**kwargs)
    end

    #
    # Invokes the command with the given argv.
    #
    # @param [String] name
    #   The name of the command to invoke.
    #
    # @param [Array<String>] argv
    #   The additional arguments to pass to the command.
    #
    # @return [Integer]
    #   The exit status of the command.
    #
    # @api semipublic
    #
    def invoke(name,*argv)
      if (command = command(name))
        command.main(argv)
      else
        on_unknown_command(name,argv)
      end
    end

    #
    # Prints an error about an unknown command and exits with an error code.
    #
    # @param [String] name
    #   The command name.
    #
    # @api semipublic
    #
    def command_not_found(name)
      print_error "'#{name}' is not a #{command_name} command. See `#{command_name} help`"
      exit(1)
    end

    #
    # Place-holder method that is called when the subcommand is not known.
    #
    # @param [String] name
    #   The given sub-command name.
    #
    # @param [Array<String>] argv
    #   Additional argv.
    #
    # @abstract
    #
    # @see command_not_found
    #
    # @api semipublic
    #
    def on_unknown_command(name,argv=[])
      command_not_found(name)
    end

    #
    # Runs the command or specified subcommand.
    #
    # @note If no subcommand is given, {#help} will be called.
    #
    # @api public
    #
    def run(command=nil,*argv)
      if command
        exit invoke(command,*argv)
      else
        help
        exit(1)
      end
    end

    #
    # Prints the available commands and their summaries.
    #
    # @api semipublic
    #
    def help_commands
      unless self.class.commands.empty?
        puts
        puts "Commands:"

        command_aliases = Hash.new { |hash,key| hash[key] = [] }

        self.class.command_aliases.each do |alias_name,name|
          command_aliases[name] << alias_name
        end

        self.class.commands.sort.each do |name,subcommand|
          names = [name, *command_aliases[name]].join(', ')

          if subcommand.summary
            puts "    #{names}\t#{subcommand.summary}"
          else
            puts "    #{names}"
          end
        end
      end
    end

    #
    # Prints help information and available commands.
    #
    # @api public
    #
    def help
      super

      help_commands
    end
  end
end
