require 'spec_helper'
require 'command_kit/options/quiet'

describe CommandKit::Options::Quiet do
  module TestOptionsQuiet
    class TestCommand
      include CommandKit::Options::Quiet
    end
  end

  let(:command_class) { TestOptionsQuiet::TestCommand }

  describe ".included" do
    subject { command_class }

    it "must include CommandKit::Options" do
      expect(subject).to include(CommandKit::Options)
    end

    it "must define a quiet option" do
      expect(subject.options[:quiet]).to_not be(nil)
      expect(subject.options[:quiet].short).to eq('-q')
      expect(subject.options[:quiet].long).to eq('--quiet')
      expect(subject.options[:quiet].desc).to eq('Enables quiet output')
    end
  end

  subject { command_class.new }

  describe "#quiet?" do
    context "when @quiet is true" do
      before do
        subject.instance_variable_set('@quiet',true)
      end

      it "must return true" do
        expect(subject.quiet?).to be(true)
      end
    end

    context "when @quiet is false" do
      before do
        subject.instance_variable_set('@quiet',false)
      end

      it "must return false" do
        expect(subject.quiet?).to be(false)
      end
    end
  end
end
