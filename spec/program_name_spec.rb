require 'spec_helper'
require 'command_kit/program_name'

describe ProgramName do
  let(:command_class) do
    Class.new.tap do |klass|
      klass.include(described_class)
    end
  end

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
  end

  describe "#program_name" do
    subject { command_class.new }

    it "should be the same as .program_name" do
      expect(subject.program_name).to eq(command_class.program_name)
    end
  end

  after do
    $PROGRAM_NAME = @original_program_name
  end
end
