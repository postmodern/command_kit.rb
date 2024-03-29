require 'spec_helper'
require 'command_kit/program_name'

describe CommandKit::ProgramName do
  module TestProgramName
    class TestCmd
      include CommandKit::ProgramName
    end
  end

  let(:command_class) { TestProgramName::TestCmd }
  let(:program_name) { 'foo' }

  before do
    @original_program_name = $PROGRAM_NAME
    $PROGRAM_NAME = program_name
  end

  describe ".program_name" do
    subject { command_class }

    it "must return $PROGRAM_NAME" do
      expect(subject.program_name).to eq(program_name)
    end

    context "when $PROGRAM_NAME is '-e'" do
      let(:program_name) { '-e' }

      it "must return nil" do
        expect(subject.program_name).to be(nil)
      end
    end

    context "when $PROGRAM_NAME is 'irb'" do
      let(:program_name) { 'irb' }

      it "must return nil" do
        expect(subject.program_name).to be(nil)
      end
    end

    context "when $PROGRAM_NAME is 'rspec'" do
      let(:program_name) { 'rspec' }

      it "must return nil" do
        expect(subject.program_name).to be(nil)
      end
    end
  end

  describe "#program_name" do
    subject { command_class.new }

    it "should be the same as .program_name" do
      expect(subject.program_name).to eq(command_class.program_name)
    end
  end

  describe "#command_name" do
    subject { command_class.new }

    it "should be the same as #program_name" do
      expect(subject.command_name).to eq(subject.program_name)
    end
  end

  after do
    $PROGRAM_NAME = @original_program_name
  end
end
