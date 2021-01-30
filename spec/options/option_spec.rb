require 'spec_helper'
require 'command_kit/options/option'

describe Options::Option do
  let(:name)   { :foo    }
  let(:short)  { nil     }
  let(:long)   { '--foo' }
  let(:equals) { false   }
  let(:value) do
    {
      usage:    'FOO',
      required: true
    }
  end
  let(:desc)  { 'Foo option' }
  let(:block) do
    ->(arg) { @foo = arg }
  end

  subject do
    described_class.new name, short:  short,
                              long:   long,
                              equals: equals,
                              desc:   desc,
                              value:  value,
                              &block
  end

  describe "#initialize" do
    context "when the short: keyword is given" do
      subject { described_class.new(name, short: short, desc: desc) }

      it "must set #short" do
        expect(subject.short).to eq(short)
      end
    end

    context "when the short: keyword is not given" do
      subject { described_class.new(name, desc: desc) }

      it { expect(subject.short).to be(nil) }
    end

    context "when the long: keyword is given" do
      let(:long) { '--opt' }

      subject { described_class.new(name, long: long, desc: desc) }

      it "must set #long" do
        expect(subject.long).to eq(long)
      end
    end

    context "when the long: keyword is not given" do
      subject { described_class.new(name, desc: desc) }

      it "default #long to a '--option' flag based on #name" do
        expect(subject.long).to eq("--#{name}")
      end
    end

    context "when the equals: keyword is given" do
      let(:equals) { true }

      subject { described_class.new(name, equals: equals, desc: desc) }

      it "must set #equals" do
        expect(subject.equals).to eq(equals)
      end
    end

    context "when the equals: keyword is not given" do
      subject { described_class.new(name, desc: desc) }

      it { expect(subject.equals).to be(false) }
    end

    context "when the values: keyword is given" do
      let(:value) { {} }
      subject { described_class.new(name, value: {}, desc: desc) }

      it "must initialize #value" do
        expect(subject.value).to be_kind_of(Options::OptionValue)
      end
    end

    context "when the values: keyword is not given" do
      subject { described_class.new(name, desc: desc) }

      it { expect(subject.value).to be(nil) }
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

    context "when a block is given" do
      subject { described_class.new(name, desc: desc, &block) }

      it "must set #block" do
        expect(subject.block).to eq(block)
      end
    end

    context "when no block is given" do
      subject { described_class.new(name, desc: desc) }

      it { expect(subject.block).to be(nil) }
    end
  end

  describe "#equals?" do
    context "when initialized with equals: true" do
      let(:equals) { true }

      it { expect(subject.equals?).to be(true) }
    end

    context "when initialized with equals: false" do
      let(:equals) { false }

      it { expect(subject.equals?).to be(false) }
    end
  end

  describe "#separator" do
    context "when #value is initialized" do
      context "and #equals? is true" do
        let(:equals) { true }

        it { expect(subject.separator).to eq('=') }
      end

      context "and #equals? is false" do
        let(:equals) { false }

        it { expect(subject.separator).to eq(' ') }
      end
    end

    context "when #value is not initialized" do
      let(:value) { nil }

      it { expect(subject.separator).to be(nil) }
    end
  end

  describe "#usage" do
    let(:long) { '--foo' }

    it "must start with the long '--option'" do
      expect(subject.usage.last).to start_with(long)
    end

    context "when #value is initialized" do
      it "must return '--option USAGE'" do
        expect(subject.usage.last).to eq("#{long} #{subject.value.usage}")
      end

      context "and #equals? is true" do
        let(:equals) { true }

        it "must return '--option=USAGE'" do
          expect(subject.usage.last).to eq("#{long}=#{subject.value.usage}")
        end
      end
    end

    context "when #short is not nil" do
      let(:short) { '-f' }

      it "to have two elements" do
        expect(subject.usage.length).to eq(2)
      end

      it "the first element should be the short option" do
        expect(subject.usage[0]).to eq(short)
      end
    end
  end

  describe "#value?" do
    context "when #value has been initialized" do
      let(:value) { {} }

      it { expect(subject.value?).to be(true) }
    end

    context "when #value has not been initialized" do
      let(:value) { nil }

      it { expect(subject.value?).to be(false) }
    end
  end

  describe "#type" do
    context "when #value has been initialized and has a #type" do
      let(:type)  { String }
      let(:value) { {type: type} }

      it "must return the #value.type" do
        expect(subject.type).to eq(type)
      end
    end

    context "when #value has not been initialized" do
      let(:value) { nil }

      it { expect(subject.type).to be(nil) }
    end
  end

  describe "#default_value" do
    context "when #value has been initialized and has a #default" do
      let(:default)  { "" }
      let(:value) { {default: default} }

      it "must return the #value.default_value" do
        expect(subject.default_value).to eq(default)
      end
    end

    context "when #value has not been initialized" do
      let(:value) { nil }

      it { expect(subject.default_value).to be(nil) }
    end
  end

  describe "#desc" do
    let(:desc) { 'Foo option' }

    it "must return the desc: value" do
      expect(subject.desc).to eq(desc)
    end

    context "when #value has been initialized with a default value" do
      let(:default)  { "foo" }
      let(:value) { {default: default} }

      it "should reutrn the desc value and '(Default: ...)'" do
        expect(subject.desc).to eq("#{desc} (Default: #{default})")
      end
    end
  end
end
