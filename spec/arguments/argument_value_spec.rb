require 'spec_helper'
require 'command_kit/arguments/argument_value'

describe CommandKit::Arguments::ArgumentValue do
  let(:type)     { String }
  let(:required) { false  }
  let(:default)  { "foo"  }
  let(:usage)    { 'FOO'  }

  subject do
    described_class.new(
      type:     type,
      required: required,
      default:  default,
      usage:    usage
    )
  end

  describe "#initialize" do
    it "must require a usage: keyword"do
      expect {
        described_class.new(type: type, required: required, default: default)
      }.to raise_error(ArgumentError)
    end

    context "when type: is given" do
      subject { described_class.new(type: type, usage: usage) }

      it "must set #type" do
        expect(subject.type).to eq(type)
      end
    end

    context "when type: is not given" do
      subject { described_class.new(usage: usage) }

      it "must default to nil" do
        expect(subject.type).to be_nil
      end
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

    context "when default: is given" do
      subject { described_class.new(default: default, usage: usage) }

      it "must set #default" do
        expect(subject.default).to eq(default)
      end
    end

    context "when default: is not given" do
      subject { described_class.new(usage: usage) }

      it "must default to nil" do
        expect(subject.default).to be_nil
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

  describe "#default_value" do
    context "when initialized with a default: that responded to #call" do
      let(:default) do
        ->{ [] }
      end

      it "must call the default #call method" do
        expect(subject.default_value).to eq(default.call)
      end
    end

    context "when initialized with a default: that it's an Object" do
      let(:default) { "" }

      it "must return the default: object" do
        expect(subject.default_value).to eq(default)
      end

      it "must duplicate the default: object each time" do
        expect(subject.default_value).to_not be(subject.default_value)
      end
    end
  end
end
