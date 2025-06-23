require 'spec_helper'
require 'command_kit/options/option_value'

describe CommandKit::Options::OptionValue do
  let(:type)     { Integer }
  let(:usage)    { 'COUNT' }
  let(:required) { true }
  let(:default)  { 1 }

  describe ".default_usage" do
    subject { described_class }

    context "when given a Hash" do
      let(:type) do
        {'foo' => :foo, "bar" => :bar}
      end

      it "must join the Hash's keys with a '|' character" do
        expect(subject.default_usage(type)).to eq(type.keys.join('|'))
      end
    end

    context "when given an Array" do
      let(:type) do
        ['foo', 'bar', 'baz']
      end

      it "must join the Array's elements with a '|' character" do
        expect(subject.default_usage(type)).to eq(type.join('|'))
      end
    end

    context "when given a Regexp" do
      let(:type) { /[0-9a-f]+/ }

      it "must return the Regexp's source" do
        expect(subject.default_usage(type)).to eq(type.source)
      end
    end

    context "when given a Class" do
      module TestOptionValue
        class FooBarBaz
        end
      end

      let(:type) { TestOptionValue::FooBarBaz }

      it "must return the uppercase and underscored version of it's name" do
        expect(subject.default_usage(type)).to eq("FOO_BAR_BAZ")
      end
    end

    context "when given another kind of Object" do
      let(:type) { Object.new }

      it do
        expect {
          subject.default_usage(type)
        }.to raise_error(TypeError,"unsupported option type: #{type.inspect}")
      end
    end
  end

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

    context "when the default: keyword is given" do
      subject { described_class.new(default: default) }

      it "must set #default" do
        expect(subject.default).to eq(default)
      end
    end

    context "when the default: keyword is not given" do
      subject { described_class.new() }

      it "default #default to String" do
        expect(subject.default).to eq(nil)
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

  subject do
    described_class.new(
      type:     type,
      usage:    usage,
      required: required,
      default:  default
    )
  end

  describe "#usage" do
    let(:usage) { 'FOO' }

    context "when #optional? is true" do
      let(:required) { false }

      it "must wrap the usage within [ ] brackets" do
        expect(subject.usage).to eq("[#{usage}]")
      end
    end

    context "when #optional? is false" do
      let(:required) { true }

      it "should return the usage string unchanged" do
        expect(subject.usage).to eq(usage)
      end
    end
  end

  describe "#default_value" do
    context "when initialized with a default: that responded to #call" do
      let(:default) do
        -> { [] }
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
