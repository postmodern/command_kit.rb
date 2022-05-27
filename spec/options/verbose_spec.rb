require 'spec_helper'
require 'command_kit/options/verbose'

describe CommandKit::Options::Verbose do
  module TestOptionsVerbose
    class TestCommand
      include CommandKit::Options::Verbose
    end
  end

  let(:command_class) { TestOptionsVerbose::TestCommand }

  describe ".included" do
    subject { command_class }

    it "must include CommandKit::Options" do
      expect(subject).to include(CommandKit::Options)
    end

    it "must define a verbose option" do
      expect(subject.options[:verbose]).to_not be(nil)
      expect(subject.options[:verbose].short).to eq('-v')
      expect(subject.options[:verbose].long).to eq('--verbose')
      expect(subject.options[:verbose].desc).to eq('Enables verbose output')
    end
  end

  subject { command_class.new }

  describe "#verbose?" do
    context "when @verbose is true" do
      before do
        subject.instance_variable_set('@verbose',true)
      end

      it "must return true" do
        expect(subject.verbose?).to be(true)
      end
    end

    context "when @verbose is false" do
      before do
        subject.instance_variable_set('@verbose',false)
      end

      it "must return false" do
        expect(subject.verbose?).to be(false)
      end
    end
  end
end
