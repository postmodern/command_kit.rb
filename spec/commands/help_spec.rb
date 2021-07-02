require 'spec_helper'
require 'command_kit/commands/help'
require 'command_kit/commands'

describe CommandKit::Commands::Help do
  module TestHelpCommand
    class CLI
      include CommandKit::Commands

      class Test < CommandKit::Command
      end

      class TestWithoutHelp
      end

      command Test
      command 'test-without-help', TestWithoutHelp
    end
  end

  let(:parent_command_class) { TestHelpCommand::CLI }
  let(:parent_command) { parent_command_class.new }
  let(:command_class) { CommandKit::Commands::Help }

  subject { command_class.new(parent_command: parent_command) }

  describe ".run" do
    context "when giving no arguments" do
      it "must call the parent command's #help method" do
        expect(parent_command).to receive(:help).with(no_args)

        subject.run
      end
    end

    context "when given a command name" do
      let(:command) { 'test' }

      it "must lookup the command and call it's #help method" do
        expect_any_instance_of(parent_command_class::Test).to receive(:help)

        subject.run(command)
      end

      context "but the command does not define a #help method" do
        let(:command) { 'test-without-help' }

        it do
          expect { subject.run(command) }.to raise_error(TypeError)
        end
      end

      context "but the command name is invalid" do
        let(:command) { 'xxx' }

        it "must print an error message and exit with 1" do
          expect(subject).to receive(:exit).with(1)

          expect { subject.run(command) }.to output(
            "#{subject.command_name}: unknown command: #{command}#{$/}"
          ).to_stderr
        end
      end
    end
  end
end
