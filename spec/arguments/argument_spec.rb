require 'spec_helper'
require 'command_kit/arguments/argument'

describe Arguments::Argument do
  let(:name)     { :foo }
  let(:type)     { String }
  let(:usage)    { 'FOO' }
  let(:default)  { 'foo' }
  let(:required) { true }
  let(:repeats)  { false }
  let(:desc)     { 'Foo argument' }

  subject do
    described_class.new name, type:     type,
                              usage:    usage,
                              default:  default,
                              required: required,
                              repeats:  repeats,
                              desc:     desc
  end

  describe "#initialize" do
    context "when the type: keyword is given" do
      subject { described_class.new(name, type: type, desc: desc) }

      it "must set #type" do
        expect(subject.type).to eq(type)
      end
    end

    context "when the type: keyword is not given" do
      subject { described_class.new(name, desc: desc) }

      it "default #type to String" do
        expect(subject.type).to eq(String)
      end
    end

    context "when the usage: keyword is given" do
      subject { described_class.new(name, usage: usage, desc: desc) }

      it "must include usage: in #usage" do
        expect(subject.usage).to include(usage)
      end
    end

    context "when the usage: keyword is not given" do
      subject { described_class.new(name, desc: desc) }

      it "should use uppercased argument name in #usage" do
        expect(subject.usage).to include(name.to_s.upcase)
      end
    end

    context "when the default: keyword is given" do
      subject { described_class.new(name, default: default, desc: desc) }

      it "must set #default" do
        expect(subject.default).to eq(default)
      end
    end

    context "when the default: keyword is not given" do
      subject { described_class.new(name, desc: desc) }

      it "default #default to String" do
        expect(subject.default).to eq(nil)
      end
    end

    context "when the required: keyword is given" do
      subject { described_class.new(name, required: required, desc: desc) }

      it "must set #required" do
        expect(subject.required).to eq(required)
      end
    end

    context "when the required: keyword is not given" do
      subject { described_class.new(name, desc: desc) }

      it "default #required to String" do
        expect(subject.required).to eq(true)
      end
    end

    context "when the repeats: keyword is given" do
      subject { described_class.new(name, repeats: repeats, desc: desc) }

      it "must set #repeats" do
        expect(subject.repeats).to eq(repeats)
      end
    end

    context "when the repeats: keyword is not given" do
      subject { described_class.new(name, desc: desc) }

      it "default #repeats to String" do
        expect(subject.repeats).to eq(false)
      end
    end

    context "when the desc: keyword is given" do
      subject { described_class.new(name, desc: desc) }

      it "must set #desc" do
        expect(subject.desc).to eq(desc)
      end
    end

    context "when the desc: keyword is not given" do
      it do
        expect {
          described_class.new(name)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#repeats?" do
    context "when initialized with repeats: true" do
      let(:repeats) { true }

      it { expect(subject.repeats?).to be(true) }
    end

    context "when initialized with repeats: false" do
      let(:repeats) { false }

      it { expect(subject.repeats?).to be(false) }
    end
  end

  describe "#usage" do
    let(:usage) { 'FOO' }

    context "initialized with required: true" do
      let(:required) { true }

      it "must return the usage unchanged" do
        expect(subject.usage).to eq(usage)
      end
    end

    context "initialized with required: false" do
      let(:required) { false }

      it "must wrap the usage in [ ] brackets" do
        expect(subject.usage).to eq("[#{usage}]")
      end
    end

    context "initialized with repeats: true" do
      let(:repeats) { true }

      it "must append the ... ellipses" do
        expect(subject.usage).to eq("#{usage} ...")
      end
    end

    context "initialized with repeats: false" do
      let(:repeats) { false }

      it "must return the usage name unchanged" do
        expect(subject.usage).to eq("#{usage}")
      end
    end
  end

  describe "#match" do
    let(:arg) { 'foo' }

    it "must call the #match method of the OptionParser accept pattern" do
      expect(subject.pattern).to receive(:match).with(arg)

      subject.match(arg)
    end

    context "when type is a Regexp" do
      let(:type) { /foo/ }

      it "must call #match on the type Regexp" do
        expect(subject.type).to receive(:match).with(arg)

        subject.match(arg)
      end
    end
  end
end
