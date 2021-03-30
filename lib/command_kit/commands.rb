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

    module ModuleMethods
      #
      # Includes {CommandName}, {Usage}, {Stdio}, {Env}, and extends
      # {ClassMethods}.
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
      # The registered sub-commands.
      #
      # @return [Hash{String => Subcommand}]
      #   The Hash of sub-command names and command classes.
      # 
      def commands
        @commands ||= if superclass.kind_of?(ClassMethods)
                         superclass.commands.dup
                       else
                         {'help' => Subcommand.new(Help)}
                       end
      end

      #
      # Mounts a command as a sub-command.
      #
      # @param [#to_s] name
      #   The optional name to mount the command as. Defaults to the command's
      #   {CommandName::ClassMethods#command_name command_name}.
      #
      # @param [Class<Subcommand>] command_class
      #   The sub-command class.
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
      def command(name=nil, command_class, **kwargs)
        name ||= command_class.command_name

        commands[name.to_s] = Subcommand.new(command_class, **kwargs)
      end
    end

    def initialize(**kwargs)
      super(**kwargs)

      @option_parser.on(Regexp.union(self.class.commands.keys)) do |command|
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
    def command(name)
      name = name.to_s

      unless (subcommand = self.class.commands[name])
        return
      end

      command = subcommand.command
      kwargs  = {}

      if command.include?(ParentCommand)
        kwargs[:parent_command] = self
      end

      if command.include?(CommandName)
        kwargs[:command_name] = "#{command_name} #{command.command_name}"
      end

      if command.include?(Stdio)
        kwargs[:stdin]  = stdin
        kwargs[:stdout] = stdout
        kwargs[:stderr] = stderr
      end

      if command.include?(Env)
        kwargs[:env] = env.dup
      end

      if command.include?(Options)
        kwargs[:options] = options.dup
      end

      return command.new(**kwargs)
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
    def invoke(name,*argv)
      if (subcommand = command(name))
        subcommand.main(argv)
      else
        on_unknown_command(name,argv)
      end
    end

    #
    # Prints an error about an unknown command and exits with an error code.
    #
    # @param [String] name
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
    def on_unknown_command(name,argv=[])
      command_not_found(name)
    end

    #
    # Runs the command or specified subcommand.
    #
    # @note If no subcommand is given, {#help} will be called.
    #
    def run(command=nil,*argv)
      if command
        exit invoke(command,*argv)
      else
        help
      end
    end

    #
    # Prints the available commands and their summaries.
    #
    def help_commands
      unless self.class.commands.empty?
        puts
        puts "Commands:"

        self.class.commands.sort.each do |name,subcommand|
          if subcommand.summary
            puts "    #{name}\t#{subcommand.summary}"
          else
            puts "    #{name}"
          end
        end
      end
    end

    #
    # Prints help information and available commands.
    #
    def help
      super

      help_commands
    end
  end
end
