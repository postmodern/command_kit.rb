require 'spec_helper'
require 'command_kit/inflector'

describe Inflector do
  describe ".demodularize" do
    context "when given a single class or module name" do
      let(:name) { 'Foo' }

      it "must return the class or module name unchanged" do
        expect(subject.demodularize(name)).to eq(name)
      end
    end

    context "when given a class or module name with a leading namespace" do
      let(:namespace) { 'Foo::Bar' }
      let(:constant)  { "Baz" }
      let(:name) { "#{namespace}::#{constant}" }

      it "must return the constant name, without the leading namespace" do
        expect(subject.demodularize(name)).to eq(constant)
      end
    end
  end

  describe ".underscore" do
    it "must convert CamelCase to camel_case" do
      expect(subject.underscore('CamelCase')).to eq('camel_case')
    end

    it "must convert camelCase to camel_case" do
      expect(subject.underscore('camelCase')).to eq('camel_case')
    end

    it "must convert Camel to camel" do
      expect(subject.underscore('Camel')).to eq('camel')
    end

    it "must convert CAMEL to camel" do
      expect(subject.underscore('CAMEL')).to eq('camel')
    end

    context "when given a non-String" do
      it "must convert it to a String" do
        expect(subject.underscore(:CamelCase)).to eq('camel_case')
      end
    end
  end

  describe ".dasherize" do
    it "must replace all underscores with dashes" do
      expect(subject.dasherize("foo_bar")).to eq('foo-bar')
    end

    context "when given a non-String" do
      it "must convert it to a String" do
        expect(subject.dasherize(:foo_bar)).to eq('foo-bar')
      end
    end
  end
end
