require 'spec_helper'
require 'command_kit/arguments/argument_value'

describe CommandKit::Arguments::ArgumentValue do
  let(:required) { false  }
  let(:usage)    { 'FOO'  }

  subject do
    described_class.new(
      required: required,
      usage:    usage
    )
  end

  describe "#initialize" do
    it "must require a usage: keyword"do
      expect {
        described_class.new(required: required)
      }.to raise_error(ArgumentError)
    end

    context "when required: is given" do
      subject { described_class.new(required: required, usage: usage) }

      it "must set #required" do
        expect(subject.required).to eq(required)
      end
    end

    context "when required: is not given" do
      subject { described_class.new(usage: usage) }

      it "must default to true" do
        expect(subject.required).to be(true)
      end
    end
  end

  describe "#required?" do
    context "when required: is initialized with true" do
      let(:required) { true }

      it { expect(subject.required?).to be(true) }
    end

    context "when required: is initialized with false" do
      let(:required) { false }

      it { expect(subject.required?).to be(false) }
    end
  end

  describe "#optional?" do
    context "when required: is initialized with true" do
      let(:required) { true }

      it { expect(subject.optional?).to be(false) }
    end

    context "when required: is initialized with false" do
      let(:required) { false }

      it { expect(subject.optional?).to be(true) }
    end
  end
end
