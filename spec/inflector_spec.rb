require 'spec_helper'
require 'command_kit/inflector'

describe Inflector do
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
