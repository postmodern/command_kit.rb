require 'spec_helper'
require 'command_kit/commands/subcommand'
require 'command_kit/command'

describe CommandKit::Commands::Subcommand do
  module TestSubcommands
    class TestCommand < CommandKit::Command
    end

    class TestCommandWithoutDescription
    end

    class TestCommandWithASentenceFragmentDescription
      include CommandKit::Description

      description "The quick brown fox"
    end

    class TestCommandWithASingleSentenceDescription
      include CommandKit::Description

      description "The quick brown fox jumps over the lazy dog."
    end

    class TestCommandWithAMultiSentenceDescription
      include CommandKit::Description

      description "The quick brown fox jumps over the lazy dog. Foo bar baz."
    end
  end

  describe "#initialize" do
    let(:command_class) { TestSubcommands::TestCommand }

    subject { described_class.new(command_class) }

    it "must initialize the subcommand with a given command class" do
      expect(subject.command).to be(command_class)
    end

    context "when the command class has no description" do
      it "#summary must be nil" do
        expect(subject.summary).to be(nil)
      end
    end

    context "when the command class have a description" do
      let(:command_class) { TestSubcommands::TestCommandWithAMultiSentenceDescription }

      it "must extract the summary using .summary" do
        expect(subject.summary).to eq(described_class.summary(command_class))
      end
    end

    context "when given aliases:" do
      let(:aliases) { %w[test t] }

      subject { described_class.new(command_class, aliases: aliases) }

      it "must initialize #aliases" do
        expect(subject.aliases).to eq(aliases)
      end
    end
  end

  describe ".summary" do
    subject { described_class.summary(command_class) }

    context "when the command class does respond_to?(:description)" do
      let(:command_class) { TestSubcommands::TestCommandWithoutDescription }

      it { expect(subject).to be(nil) }
    end

    context "when the command class has a sentence fragment description" do
      let(:command_class) { TestSubcommands::TestCommandWithASentenceFragmentDescription }

      it "must return the sentence fragment" do
        expect(subject).to eq(command_class.description)
      end
    end

    context "when the command class has a single sentence description" do
      let(:command_class) { TestSubcommands::TestCommandWithASingleSentenceDescription }

      it "must return the single sentence without the terminating period" do
        expect(subject).to eq(command_class.description.chomp('.'))
      end
    end

    context "when the command class has a multi-sentence description" do
      let(:command_class) { TestSubcommands::TestCommandWithAMultiSentenceDescription }

      it "must extract the first sentence, without the terminating period" do
        expect(subject).to eq(command_class.description.split(/\.\s*/).first)
      end
    end
  end
end
