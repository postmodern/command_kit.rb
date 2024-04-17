require 'spec_helper'
require 'command_kit/options/verbose_level'

describe CommandKit::Options::VerboseLevel do
  module TestOptionsVerboseLevel
    class TestCommand
      include CommandKit::Options::VerboseLevel
    end
  end

  let(:command_class) { TestOptionsVerboseLevel::TestCommand }

  describe ".included" do
    subject { command_class }

    it "must include CommandKit::Options" do
      expect(subject).to include(CommandKit::Options)
    end

    it "must define a verbose option" do
      expect(subject.options[:verbose]).to_not be(nil)
      expect(subject.options[:verbose].short).to eq('-v')
      expect(subject.options[:verbose].long).to eq('--verbose')
      expect(subject.options[:verbose].desc).to eq('Increases the verbosity level')
    end
  end

  subject { command_class.new }

  describe "options" do
    context "when -v is given once" do
      let(:argv) { %w[-v] }

      before { subject.option_parser.parse(argv) }

      it "must set #verbose to 1" do
        expect(subject.verbose).to eq(1)
      end
    end

    context "when -v is given twice" do
      let(:argv) { %w[-vv] }

      before { subject.option_parser.parse(argv) }

      it "must set #verbose to 2" do
        expect(subject.verbose).to eq(2)
      end
    end

    context "when -v is given three times" do
      let(:argv) { %w[-vvv] }

      before { subject.option_parser.parse(argv) }

      it "must set #verbose to 3" do
        expect(subject.verbose).to eq(3)
      end
    end

    context "when --verbose is given once" do
      let(:argv) { %w[--verbose] }

      before { subject.option_parser.parse(argv) }

      it "must set #verbose to 1" do
        expect(subject.verbose).to eq(1)
      end
    end

    context "when --verbose is given twice" do
      let(:argv) { %w[--verbose --verbose] }

      before { subject.option_parser.parse(argv) }

      it "must set #verbose to 2" do
        expect(subject.verbose).to eq(2)
      end
    end

    context "when --verbose is given three times" do
      let(:argv) { %w[--verbose --verbose --verbose] }

      before { subject.option_parser.parse(argv) }

      it "must set #verbose to 3" do
        expect(subject.verbose).to eq(3)
      end
    end
  end

  describe "#initialize" do
    it "must default #verbose to 0" do
      expect(subject.verbose).to eq(0)
    end
  end

  describe "#verbose" do
    let(:verbose_level) { 1 }

    before do
      subject.instance_variable_set('@verbose',verbose_level)
    end

    it "must return the verbose level" do
      expect(subject.verbose).to eq(verbose_level)
    end
  end

  describe "#verbose?" do
    context "when @verbose is 0" do
      before do
        subject.instance_variable_set('@verbose',0)
      end

      it "must return false" do
        expect(subject.verbose?).to be(false)
      end
    end

    context "when @verbose is 1" do
      before do
        subject.instance_variable_set('@verbose',1)
      end

      it "must return true" do
        expect(subject.verbose?).to be(true)
      end
    end

    context "when @verbose is greater than 1" do
      before do
        subject.instance_variable_set('@verbose',2)
      end

      it "must return true" do
        expect(subject.verbose?).to be(true)
      end
    end
  end
end
