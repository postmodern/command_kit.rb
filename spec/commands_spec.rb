require 'spec_helper'
require 'command_kit/commands'

describe CommandKit::Commands do
  module TestCommands
    class TestEmptyCommands

      include CommandKit::Commands

    end

    class TestCommands

      include CommandKit::Commands

      class Test1 < CommandKit::Command
      end

      class Test2 < CommandKit::Command
      end

      p method(:command).source_location
      command Test1
      command Test2

    end

    class TestCommandsWithAliases

      include CommandKit::Commands

      class Test1 < CommandKit::Command
      end

      class Test2 < CommandKit::Command
      end

      command Test1, aliases: %w[t1]
      command Test2, aliases: %w[t2]

    end

    class TestCommandsWithExplicitNames

      include CommandKit::Commands

      class Test1 < CommandKit::Command
      end

      class Test2 < CommandKit::Command
      end

      command 'command-name-1', Test1
      command 'command-name-2', Test2

    end

    class TestCommandsWithExplicitNamesAndAliases

      include CommandKit::Commands

      class Test1 < CommandKit::Command
      end

      class Test2 < CommandKit::Command
      end

      command 'command-name-1', Test1, aliases: %w[t1]
      command 'command-name-2', Test2, aliases: %w[t2]

    end

    class TestCommandsWithExplicitSummaries

      include CommandKit::Commands

      class Test1 < CommandKit::Command
      end

      class Test2 < CommandKit::Command
      end

      command Test1, summary: 'Explicit summary 1'
      command Test2, summary: 'Explicit summary 2'

    end

    class TestCommandsWithCustomExitStatus

      include CommandKit::Commands

      class Test < CommandKit::Command

        def run(*argv)
          exit(2)
        end

      end

      command Test

    end

    class TestCommandsWithGlobalOptions

      include CommandKit::Commands

      class Test1 < CommandKit::Command
      end

      class Test2 < CommandKit::Command
      end

      option :foo, short: '-f',
                   desc: "Global --foo option"

      option :bar, short: '-b',
                   value: {
                     required: true,
                     type: String,
                     usage: 'BAR'
                   },
                   desc: "Global --bar option"

      command Test1
      command Test2

    end
  end

  let(:command_class) { TestCommands::TestCommands }

  describe ".commands" do
    subject { command_class }

    it "must return a Hash" do
      expect(subject.commands).to be_kind_of(Hash)
    end

    it "must provide a default 'help' command" do
      expect(subject.commands['help']).to_not be_nil
      expect(subject.commands['help'].command).to eq(CommandKit::Commands::Help)
    end

    context "when additional commands are defined in a superclass" do
      module TestCommands
        class TestInheritedCommands < TestCommands

          class Test3 < CommandKit::Command

            def run
              puts 'test command three'
            end

          end

          command :test3, Test3

        end
      end

      let(:command_superclass) { TestCommands::TestCommands }
      let(:command_class)      { TestCommands::TestInheritedCommands }

      it "must inherit the superclass'es commands" do
        expect(subject.commands['test1']).to eq(command_superclass.commands['test1'])
        expect(subject.commands['test2']).to eq(command_superclass.commands['test2'])
      end

      it "must allow defining additional commands in the subclass" do
        expect(subject.commands['test3']).to_not be_nil
        expect(subject.commands['test3'].command).to eq(command_class::Test3)
      end

      it "must not change the superclass'es commands" do
        expect(command_superclass.commands['test3']).to be(nil)
      end
    end
  end

  describe ".command_aliases" do
    subject { command_class }

    it "must return an empty Hash by default" do
      expect(subject.command_aliases).to eq({})
    end

    context "when commands have aliases" do
      let(:command_class) { TestCommands::TestCommandsWithAliases }

      it "must contain the mapping of aliases to command names" do
      expect(subject.command_aliases).to eq({
        't1' => 'test1',
        't2' => 'test2',
      })
      end
    end

    context "when additional command aliases are defined in a superclass" do
      module TestCommands
        class TestInheritedCommandsWithAliases < TestCommandsWithAliases

          class Test3 < CommandKit::Command

            def run
              puts 'test command three'
            end

          end

          command :test3, Test3, aliases: %w[t3]

        end
      end

      let(:command_superclass) { TestCommands::TestCommandsWithAliases }
      let(:command_class)      { TestCommands::TestInheritedCommandsWithAliases }

      it "must inherit the superclass'es command aliases" do
        expect(subject.command_aliases['t1']).to eq(command_superclass.command_aliases['t1'])
        expect(subject.command_aliases['t2']).to eq(command_superclass.command_aliases['t2'])
      end

      it "must allow defining additional command aliases in the subclass" do
        expect(subject.command_aliases['t3']).to eq('test3')
      end

      it "must not change the superclass'es command aliases" do
        expect(command_superclass.command_aliases['test3']).to be(nil)
      end
    end
  end

  describe ".command" do
    subject { command_class }

    context "when given only a command class" do
      module TestCommands
        class TestCommandWithOnlyACommandClass
          include CommandKit::Commands

          class Test < CommandKit::Command
          end

          command Test
        end
      end

      let(:command_class) { TestCommands::TestCommandWithOnlyACommandClass }

      it "must default the command name to the command class'es command_name" do
        expect(subject.commands['test']).to_not be_nil
        expect(subject.commands['test'].command).to eq(command_class::Test)
      end

      context "and aliases:" do
        let(:command_class) { TestCommands::TestCommandsWithAliases }

        it "must populate aliases with the aliases and the command names" do
          expect(subject.command_aliases['t1']).to eq(command_class::Test1.command_name)
          expect(subject.command_aliases['t2']).to eq(command_class::Test2.command_name)
        end
      end
    end

    context "when given a command name and a command class" do
      let(:command_class) { TestCommands::TestCommandsWithExplicitNames }

      it "must not add an entry for the command class'es command_name" do
        expect(subject.commands['test1']).to be_nil
        expect(subject.commands['test2']).to be_nil
      end

      it "must add an entry for the command name" do
        expect(subject.commands['command-name-1']).to_not be_nil
        expect(subject.commands['command-name-1'].command).to eq(command_class::Test1)

        expect(subject.commands['command-name-2']).to_not be_nil
        expect(subject.commands['command-name-2'].command).to eq(command_class::Test2)
      end

      context "and aliases:" do
        let(:command_class) { TestCommands::TestCommandsWithExplicitNamesAndAliases }

        it "must populate aliases with the aliases and the explicit command names" do
          expect(subject.command_aliases['t1']).to eq('command-name-1')
          expect(subject.command_aliases['t2']).to eq('command-name-2')
        end
      end

      context "when the command name is a Symbol" do
        module TestCommands
          class TestCommandWithASymbolCommandName
            include CommandKit::Commands

            class Test < CommandKit::Command
            end

            command :test_sym, Test
          end
        end

        let(:command_class) { TestCommands::TestCommandWithASymbolCommandName }

        it "must not add an entry for the command class'es command_name" do
          expect(subject.commands['test']).to be_nil
        end

        it "must not add entries with Symbol keys" do
          expect(subject.commands.keys).to all(be_kind_of(String))
        end

        it "must convert the command name to a String" do
          expect(subject.commands['test_sym']).to_not be_nil
          expect(subject.commands['test_sym'].command).to eq(command_class::Test)
        end
      end
    end

    context "when given an explicit summary: keyword argument" do
      let(:command_class) { TestCommands::TestCommandsWithExplicitSummaries }

      it "must initialize the Subcommand#summary" do
        expect(subject.commands['test1'].summary).to eq('Explicit summary 1')
        expect(subject.commands['test2'].summary).to eq('Explicit summary 2')
      end
    end
  end

  describe ".get_command" do
    subject { command_class }

    context "when given a command name" do
      let(:command_class) { TestCommands::TestCommands }

      it "must return the command's class" do
        expect(subject.get_command('test1')).to eq(command_class::Test1)
        expect(subject.get_command('test2')).to eq(command_class::Test2)
      end
    end

    context "when given a command's alias name" do
      let(:command_class) { TestCommands::TestCommandsWithAliases }

      it "must return the command's class associated with the alias" do
        expect(subject.get_command('t1')).to eq(command_class::Test1)
        expect(subject.get_command('t2')).to eq(command_class::Test2)
      end
    end

    context "when given an unknown command name" do
      it "must return nil" do
        expect(subject.get_command('foo')).to be(nil)
      end
    end
  end

  subject { command_class.new }

  describe "#command" do
    module TestCommands
      class TestSubCommandInitialization
        include CommandKit::Commands

        class Test < CommandKit::Command
        end

        command 'test', Test
      end
    end

    let(:command_class) { TestCommands::TestSubCommandInitialization }
    let(:subcommand_class) { command_class::Test }

    context "when given a valid command name" do
      it "must lookup the command and initialize it" do
        expect(subject.command(subcommand_class.command_name)).to be_kind_of(subcommand_class)
      end
    end

    context "when given a command alias" do
      let(:command_class) { TestCommands::TestCommandsWithAliases }

      it "must lookup the command and initialize it" do
        expect(subject.command('t1')).to be_kind_of(command_class::Test1)
        expect(subject.command('t2')).to be_kind_of(command_class::Test2)
      end
    end

    context "when given an unknown command name" do
      it "must return nil" do
        expect(subject.command('foo')).to be_nil
      end
    end

    context "when the command includes CommandKit::Commands::ParentCommand" do
      module TestCommands
        class TestSubCommandInitializationWithParentCommand
          include CommandKit::Commands

          class Test
            include CommandKit::Commands::ParentCommand
          end

          command 'test', Test
        end
      end

      let(:command_class) { TestCommands::TestSubCommandInitializationWithParentCommand }
      let(:subcommand_class) { command_class::Test }

      it "must initialize the sub-command with a parent_command value" do
        subcommand = subject.command('test')

        expect(subcommand.parent_command).to be(subject)
      end
    end

    context "when the command includes CommandKit::CommandName" do
      module TestCommands
        class TestSubCommandInitializationWithCommandName
          include CommandKit::Commands

          class Test
            include CommandKit::CommandName
          end

          command 'test', Test
        end
      end

      let(:command_class) { TestCommands::TestSubCommandInitializationWithCommandName }
      let(:subcommand_class) { command_class::Test }
      let(:expected_subcommand_name) do
        "#{command_class.command_name} #{subcommand_class.command_name}"
      end

      it "must initialize the sub-command with the command and subcommand name" do
        subcommand = subject.command('test')

        expect(subcommand.command_name).to eq(expected_subcommand_name)
      end
    end

    context "when the command includes CommandKit::Stdio" do
      module TestCommands
        class TestSubCommandInitializationWithStdio
          include CommandKit::Commands

          class Test
            include CommandKit::Stdio
          end

          command 'test', Test
        end
      end

      let(:command_class) { TestCommands::TestSubCommandInitializationWithStdio }
      let(:subcommand_class) { command_class::Test }

      let(:stdin)  { StringIO.new }
      let(:stdout) { StringIO.new }
      let(:stderr) { StringIO.new }

      subject do
        command_class.new(stdin: stdin, stdout: stdout, stderr: stderr)
      end

      it "must initialize the sub-command with the command's #stdin, #stdout, #stderr" do
        subcommand = subject.command('test')

        expect(subcommand.stdin).to be(stdin)
        expect(subcommand.stdout).to be(stdout)
        expect(subcommand.stderr).to be(stderr)
      end
    end

    context "when the command includes CommandKit::Env" do
      module TestCommands
        class TestSubCommandInitializationWithEnv
          include CommandKit::Commands

          class Test
            include CommandKit::Env
          end

          command 'test', Test
        end
      end

      let(:command_class) { TestCommands::TestSubCommandInitializationWithEnv }
      let(:subcommand_class) { command_class::Test }

      let(:env) { {'FOO' => 'bar'} }
      subject { command_class.new(env: env) }

      it "must initialize the sub-command with a copy of the command's #env" do
        subcommand = subject.command('test')

        expect(subcommand.env).to eq(env)
        expect(subcommand.env).to_not be(env)
      end
    end

    context "when the command includes CommandKit::Options" do
      module TestCommands
        class TestSubCommandInitializationWithOptions
          include CommandKit::Commands

          class Test
            include CommandKit::Options
          end

          command 'test', Test
        end
      end

      let(:command_class) { TestCommands::TestSubCommandInitializationWithOptions }
      let(:subcommand_class) { command_class::Test }

      let(:options) { {foo: 'bar'} }
      subject { command_class.new(options: options) }

      it "must initialize the sub-command with a copy of the command's #options Hash" do
        subcommand = subject.command('test')

        expect(subcommand.options).to eq(options)
        expect(subcommand.options).to_not be(options)
      end
    end
  end

  describe "#invoke" do
    context "when given a valid command name" do
      let(:command_name) { 'test2' }
      let(:argv) { %w[--opt arg1 arg2] }

      it "must call the command's #main method with the given argv" do
        expect_any_instance_of(command_class::Test2).to receive(:main).with(argv)

        subject.invoke(command_name,*argv)
      end

      context "when the command returns a custom exit code" do
        let(:command_class) { TestCommands::TestCommandsWithCustomExitStatus }

        it "must return the exit code" do
          expect(subject.invoke('test')).to eq(2)
        end
      end
    end

    context "when given an unknown command name" do
      let(:command_name) { 'xxx' }
      let(:argv) { %w[--opt arg1 arg2] }

      it "must call #on_unknown_command with the given name and argv" do
        expect(subject).to receive(:on_unknown_command).with(command_name,argv)

        subject.invoke(command_name,*argv)
      end
    end
  end

  let(:unknown_command) { 'xxx' }

  describe "#command_not_found" do
    it "must print an error message to stderr and exit with 1" do
      expect(subject).to receive(:exit).with(1)

      expect { subject.command_not_found(unknown_command) }.to output(
        "'#{unknown_command}' is not a #{subject.command_name} command. See `#{subject.command_name} help`" + $/
      ).to_stderr
    end
  end

  describe "#on_unknown_command" do
    it "must call #command_not_found with the given command name by default" do
      expect(subject).to receive(:command_not_found).with(unknown_command)

      subject.on_unknown_command(unknown_command)
    end
  end

  describe "#run" do
    context "when a command name is the first argument" do
      let(:command) { 'test1' }
      let(:exit_status) { 2 }

      it "must invoke the command and exit with it's status" do
        expect(subject).to receive(:invoke).with(command).and_return(exit_status)
        expect(subject).to receive(:exit).with(exit_status)

        subject.run(command)
      end

      context "when additional argv is given after the command name" do
        let(:argv) { %w[--opt arg1 arg2] }

        it "must pass the additional argv to the command" do
          expect(subject).to receive(:invoke).with(command,*argv).and_return(exit_status)
          expect(subject).to receive(:exit).with(exit_status)

          subject.run(command,*argv)
        end
      end
    end

    context "when given no arguments" do
      it "must default to calling #help" do
        expect(subject).to receive(:help)

        subject.run()
      end
    end
  end

  describe "#option_parser" do
    let(:command_name) { 'test1'     }
    let(:command_argv) { %w[foo bar baz] }
    let(:argv) { [command_name, *command_argv] }

    it "must stop before the first non-option argument" do
      expect(subject.option_parser.parse(argv)).to eq(
        [command_name, *command_argv]
      )
    end

    context "when an unknown command name is given" do
      let(:command_argv) { %w[bar baz] }
      let(:argv) { ['foo', command_name, *command_argv] }

      it "must stop before the first non-option argument" do
        expect(subject.option_parser.parse(argv)).to eq(argv)
      end
    end

    context "when additional global options are defined" do
      let(:command_class) { TestCommands::TestCommandsWithGlobalOptions }
      let(:bar) { '2' }
      let(:argv) do
        ['--foo', '--bar', bar.to_s, command_name, *command_argv]
      end

      it "must parse the global options, but stop before the first non-option associated argument" do
        expect(subject.option_parser.parse(argv)).to eq(
          [command_name, *command_argv]
        )

        expect(subject.options[:foo]).to be(true)
        expect(subject.options[:bar]).to eq(bar)
      end
    end
  end

  describe "#help_commands" do
    it "must print usage and the list of available commands" do
      expect { subject.help_commands }.to output(
        [
          "",
          "Commands:",
          "    help",
          "    test1",
          "    test2",
          ""
        ].join($/)
      ).to_stdout
    end

    context "when the commands have custom names" do
      let(:command_class) { TestCommands::TestCommandsWithExplicitNames }

      it "must print the command names, not the command class'es #command_name" do
        expect { subject.help_commands }.to output(
          [
            "",
            "Commands:",
            "    command-name-1",
            "    command-name-2",
            "    help",
            ""
          ].join($/)
        ).to_stdout
      end
    end

    context "when the commands have summaries" do
      let(:command_class) { TestCommands::TestCommandsWithExplicitSummaries }

      it "must print the command names and their summaries" do
        expect { subject.help_commands }.to output(
          [
            "",
            "Commands:",
            "    help",
            "    test1\t#{command_class.commands['test1'].summary}",
            "    test2\t#{command_class.commands['test2'].summary}",
            ""
          ].join($/)
        ).to_stdout
      end
    end
  end

  describe "#help" do
    it "must print the list of available commands after other help output" do
      expect { subject.help }.to output(
        [
          "Usage: #{subject.command_name} [options] [COMMAND [ARGS...]]",
          "",
          "Options:",
          "    -h, --help                       Print help information",
          "",
          "Commands:",
          "    help",
          "    test1",
          "    test2",
          ""
        ].join($/)
      ).to_stdout
    end

    context "when the command has command alises" do
      let(:command_class) { TestCommands::TestCommandsWithAliases }

      it "must print the command names, along with their command aliases" do
        expect { subject.help }.to output(
          [
            "Usage: #{subject.command_name} [options] [COMMAND [ARGS...]]",
            "",
            "Options:",
            "    -h, --help                       Print help information",
            "",
            "Commands:",
            "    help",
            "    test1, t1",
            "    test2, t2",
            ""
          ].join($/)
        ).to_stdout
      end
    end

    context "when the command defines additional global options" do
      let(:command_class) { TestCommands::TestCommandsWithGlobalOptions }

      it "must print any global options" do
        expect { subject.help }.to output(
          [
            "Usage: #{subject.command_name} [options] [COMMAND [ARGS...]]",
            "",
            "Options:",
            "    -f, --foo                        Global --foo option",
            "    -b, --bar BAR                    Global --bar option",
            "    -h, --help                       Print help information",
            "",
            "Commands:",
            "    help",
            "    test1",
            "    test2",
            ""
          ].join($/)
        ).to_stdout
      end
    end
  end
end
