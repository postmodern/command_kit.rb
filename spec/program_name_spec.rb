require 'spec_helper'
require 'command_kit/program_name'

describe ProgramName do
  let(:subject_class) do
    Class.new.tap do |klass|
      klass.include(described_class)
    end
  end

  let(:program_name) { 'foo' }
  let(:program_path) { "/path/to/#{program_name}" }

  before do
    @original_0 = $0
    $0 = program_path
  end

  describe ".program_name" do
    subject { subject_class }

    it "must return the basename of $0" do
      expect(subject.program_name).to eq(program_name)
    end
  end

  describe "#program_name" do
    subject { subject_class.new }

    it "should be the same as .program_name" do
      expect(subject.program_name).to eq(subject_class.program_name)
    end
  end

  after do
    $0 = @original_0
  end
end
