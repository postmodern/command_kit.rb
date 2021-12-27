require 'spec_helper'
require 'command_kit/file_utils'
require 'tempfile'

describe CommandKit::FileUtils do
  module TestFileUtils
    class Command
      include CommandKit::FileUtils

      attr_reader :var

      def initialize(var: nil)
        super()

        @var = var
      end

      def test_method
        'some method'
      end
    end
  end

  let(:var) { 42 }

  let(:command_class) { TestFileUtils::Command }
  subject { command_class.new(var: var) }

  let(:fixtures_dir)  { File.expand_path(File.join(__dir__,'fixtures')) }
  let(:template_path) { File.join(fixtures_dir,'template.erb') }

  describe "#erb" do
    let(:expected_result) do
      [
        "Raw text",
        '',
        "variable = #{var}",
        '',
        "method = #{subject.test_method}"
      ].join($/)
    end

    context "when only given a source file argument" do
      it "must render the erb template and return the result" do
        expect(subject.erb(template_path)).to eq(expected_result)
      end
    end

    context "when given an additional destination file argument" do
      let(:dest_path) { Tempfile.new.path }

      before { subject.erb(template_path,dest_path) }

      it "must render the erb template and write the result to the destination" do
        expect(File.read(dest_path)).to eq(expected_result)
      end
    end
  end
end
