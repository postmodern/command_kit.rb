require 'spec_helper'
require 'command_kit/options/option_value'

describe Options::OptionValue do
  let(:type) { Integer }
  let(:usage)    { 'COUNT' }
  let(:required) { true }
  let(:default)  { 1 }

  describe "#initialize" do
    context "when the type: keyword is given" do
      let(:type) { Integer }

      subject { described_class.new(type: type) }

      it "must default #type to String" do
        expect(subject.type).to eq(type)
      end
    end

    context "when the type: keyword is not given" do
      subject { described_class.new }

      it "must default #type to String" do
        expect(subject.type).to eq(String)
      end
    end

    context "when the usage: keyword is given" do
      let(:usage) { 'FOO' }

      subject { described_class.new(usage: usage) }

      it "must default #usage to String" do
        expect(subject.usage).to eq(usage)
      end
    end

    context "when the usage: keyword is not given" do
      subject { described_class.new }

      it "must default #usage based on #type" do
        expect(subject.usage).to eq(described_class.default_usage(subject.type))
      end
    end
  end

  describe "#usage" do
    let(:usage) { 'FOO' }

    context "when #optional? is true" do
      subject { described_class.new(usage: usage, required: false) }

      it "must wrap the usage within [ ] brackets" do
        expect(subject.usage).to eq("[#{usage}]")
      end
    end

    context "when #optional? is false" do
      subject { described_class.new(usage: usage, required: true) }

      it "should return the usage string unchanged" do
        expect(subject.usage).to eq(usage)
      end
    end
  end
end
