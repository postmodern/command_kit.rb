require 'spec_helper'
require 'command_kit/commands/namespace'

describe Commands::Namespace do
  module TestNamespace
    class Foo
    end

    class Bar
    end

    class FooBar
    end

    class BAZ
    end
  end

  module TestEmptyNamespace
  end

  let(:namespace) { TestNamespace }
  let(:const_map) { {} }

  subject { described_class.new(namespace, const_map: const_map) }

  describe "#initialize" do
    it "must set #namespace" do
      expect(subject.namespace).to eq(namespace)
    end

    it "must default #const_map to {}" do
      expect(subject.const_map).to eq({})
    end

    context "when const_map: is given" do
      let(:const_map) { {'baz' => 'BAZ'} }

      it "must set #const_map" do
        expect(subject.const_map).to eq(const_map)
      end

      it "must duplicate the given const_map: Hash" do
        expect(subject.const_map).to_not be(const_map)
      end
    end
  end

  describe "#const_for" do
    it "must return the CamelCase version of the given name" do
      expect(subject.const_for('foo_bar')).to eq('FooBar')
    end

    context "when #const_map is populated" do
      let(:const_map) { {'baz' => 'BAZ'} }

      it "must default to returning the CamelCase version of the given name" do
        expect(subject.const_for('foo_bar')).to eq('FooBar')
      end

      context "and contains a mapping for the given name" do
        it "must use the #const_map mapping" do
          expect(subject.const_for('baz')).to eq('BAZ')
        end
      end
    end
  end

  describe "#const_get" do
    it "must return the constant for the given name" do
      expect(subject.const_get('Bar')).to eq(namespace::Bar)
    end

    context "when given the name of a constant that's globally defined" do
      it do
        expect {
          subject.const_get('Object')
        }.to raise_error(NameError)
      end
    end

    context "when given the name of a constant that isn't defined" do
      it do
        expect {
          subject.const_get('X')
        }.to raise_error(NameError)
      end
    end
  end

  describe "#const_defined?" do
    context "when given the name of a constant defined in the namespace" do
      it do
        expect(subject.const_defined?('Bar')).to be(true)
      end
    end

    context "when given the name of a constant that's globally defined" do
      it do
        expect(subject.const_defined?('Object')).to be(false)
      end
    end

    context "when given the name of a constant that isn't defined" do
      it do
        expect(subject.const_defined?('X')).to be(false)
      end
    end
  end

  describe "#constants" do
    it "must return the names of all constants defined in the namespace" do
      expect(subject.constants).to match_array([:Foo, :Bar, :FooBar, :BAZ])
    end

    context "when the namespace is empty" do
      let(:namespace) { TestEmptyNamespace }

      it do
        expect(subject.keys).to eq([])
      end
    end
  end

  describe "#has_key?" do
    context "when the given under_scored key maps to a constant's CamelCase name" do
      it do
        expect(subject.has_key?('foo')).to be(true)
      end
    end

    context "when the given under_scored key does not map to a constant's CamelCase name" do
      it do
        expect(subject.has_key?('baz')).to be(false)
      end
    end

    context "when #const_map contains a mapping for the given key" do
      context "and that mapping points to a defined constant" do
        let(:const_map) { {'baz' => 'BAZ' } }

        it do
          expect(subject.has_key?('baz')).to be(true)
        end
      end

      context "vbut that mapping does not point to a defined constant" do
        let(:const_map) { {'nope' => 'NOPE' } }

        it do
          expect(subject.has_key?('nope')).to be(false)
        end
      end
    end

    context "when given under_scored name maps to a global constant" do
      it do
        expect(subject.has_key?('object')).to be(false)
      end
    end
  end

  describe "#key?" do
    let(:key) { 'foo' }

    it "call #has_key?" do
      expect(subject).to receive(:has_key?).with(key)

      subject.key?(key)
    end
  end

  describe "#include?" do
    let(:key) { 'foo' }

    it "call #has_key?" do
      expect(subject).to receive(:has_key?).with(key)

      subject.include?(key)
    end
  end

  describe "#member?" do
    let(:key) { 'foo' }

    it "call #has_key?" do
      expect(subject).to receive(:has_key?).with(key)

      subject.member?(key)
    end
  end

  describe "#keys" do
    it "must return all under_scored key names for the constants defined in the namespace" do
      expect(subject.keys).to match_array(%w[foo bar foo_bar baz])
    end

    context "when #const_map contains mappings for some of the constants defined in the namespace" do
      let(:const_map) { {'foobar' => 'FooBar' } }

      it "should use those mappings when they match the defined constants" do
        expect(subject.keys).to match_array(%w[foo bar foobar baz])
      end
    end

    context "when the namespace is empty" do
      let(:namespace) { TestEmptyNamespace }

      it do
        expect(subject.keys).to eq([])
      end
    end
  end

  describe "#each_key" do
    it "must yield an under_scored key for each constant defined in the namespace" do
      yielded_keys = []

      subject.each_key { |key| yielded_keys << key }

      expect(yielded_keys).to match_array(%w[
        foo
        bar
        foo_bar
        baz
      ])
    end

    context "when #const_map contains mappings for some of the constants defined in the namespace" do
      let(:const_map) { {'foobar' => 'FooBar' } }

      it "should use those mappings when they match the defined constants" do
        yielded_keys = []

        subject.each_key { |key| yielded_keys << key }

        expect(yielded_keys).to match_array(%w[
          foo
          bar
          foobar
          baz
        ])
      end
    end

    context "when the namespace is empty" do
      let(:namespace) { TestEmptyNamespace }

      it do
        expect { |b| subject.each_key(&b) }.to_not yield_control
      end
    end
  end

  describe "#[]" do
    it "must return the constant that maps to the given under_scored key name" do
      expect(subject['foo_bar']).to eq(namespace::FooBar)
    end

    context "when #const_map contains mappings for some of the constants defined in the namespace" do
      let(:const_map) { {'foobar' => 'FooBar' } }

      it "should use those mappings when they match the defined constants" do
        expect(subject['foobar']).to eq(namespace::FooBar)
      end
    end

    context "when the given under_scored name does not map to a constant defined in the namespace" do
      it do
        expect(subject['nope']).to be(nil)
      end
    end

    context "when given under_scored name maps to a global constant" do
      it do
        expect(subject['object']).to be(nil)
      end
    end
  end

  describe "#fetch" do
    it "must return the constant that maps to the given under_scored key name" do
      expect(subject.fetch('foo_bar')).to eq(namespace::FooBar)
    end

    context "when #const_map contains mappings for some of the constants defined in the namespace" do
      let(:const_map) { {'foobar' => 'FooBar' } }

      it "should use those mappings when they match the defined constants" do
        expect(subject.fetch('foobar')).to eq(namespace::FooBar)
      end
    end

    context "when the given under_scored name does not map to a constant defined in the namespace" do
      let(:key) { 'nope' }

      it do
        expect { subject.fetch(key) }.to raise_error(KeyError)
      end

      context "but a default value is given" do
        let(:default) { 1 }

        it "must return the default value instead" do
          expect(subject.fetch(key,default)).to eq(default)
        end
      end

      context "but a default block is given" do
        let(:default) { 1 }
        let(:default_block) { ->() { default } }

        it "must call the default block and return it's value instead" do
          expect(subject.fetch(key,&default_block)).to eq(default)
        end
      end
    end

    context "when given under_scored name maps to a global constant" do
      let(:key) { 'object' }

      it do
        expect { subject.fetch(key) }.to raise_error(KeyError)
      end

      context "but a default value is given" do
        let(:default) { 1 }

        it "must return the default value instead" do
          expect(subject.fetch(key,default)).to eq(default)
        end
      end

      context "but a default block is given" do
        let(:default) { 1 }
        let(:default_block) { ->() { default } }

        it "must call the default block and return it's value instead" do
          expect(subject.fetch(key,&default_block)).to eq(default)
        end
      end
    end
  end
end
