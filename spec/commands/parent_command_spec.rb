require 'spec_helper'
require 'command_kit/commands'
require 'command_kit/commands/parent_command'

describe Commands::ParentCommand do
  module TestParentCommand
    class TestCommands

      include CommandKit::Commands

      class Test < CommandKit::Command
        include CommandKit::Commands::ParentCommand
      end

      command Test

    end
  end

  let(:parent_command_class) { TestParentCommand::TestCommands }
  let(:command_class) { TestParentCommand::TestCommands::Test }

  describe "#initialize" do
    context "when given a parent_command: keyword argument" do
      let(:parent_command) { parent_command_class.new }

      subject { command_class.new(parent_command: parent_command) }

      it "must initialize #parent_command" do
        expect(subject.parent_command).to be(parent_command)
      end
    end

    context "when the parent_command: keyword argument is not given" do
      it do
        expect { command_class.new }.to raise_error(ArgumentError)
      end
    end
  end
end
