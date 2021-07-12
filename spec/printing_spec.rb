require 'spec_helper'
require 'command_kit/printing'

require 'stringio'

describe CommandKit::Printing do
  module TestPrinting
    class TestCmd

      include CommandKit::Printing

    end
  end

  let(:command_class) { TestPrinting::TestCmd }
  subject { command_class.new }
  
  describe "EOL" do
    subject { described_class::EOL }

    it "must equal $/" do
      expect(subject).to eq($/)
    end
  end

  describe ".included" do
    subject { command_class }

    it { expect(command_class).to include(CommandKit::Stdio) }
  end

  let(:nl) { $/ }

  describe "#print_error" do
    let(:message) { "oh no!" }

    it "must print a line to stderr" do
      expect {
        subject.print_error(message)
      }.to output("#{message}#{nl}").to_stderr
    end
  end

  describe "#print_exception" do
    let(:message) { "error!" }
    let(:backtrace) do
      [
        "/path/to/test1.rb:1 in `test1'",
        "/path/to/test2.rb:2 in `test2'",
        "/path/to/test3.rb:3 in `test3'",
        "/path/to/test4.rb:4 in `test4'"
      ]
    end
    let(:exception) do
      error = RuntimeError.new(message)
      error.set_backtrace(backtrace)
      error
    end

    subject { command_class.new(stderr: StringIO.new) }

    context "when stderr is a TTY" do
      before { expect(subject.stderr).to receive(:tty?).and_return(true) }

      it "must print a highlighted exception" do
        subject.print_exception(exception)

        expect(subject.stderr.string).to eq(
          exception.full_message(highlight: true)
        )
      end
    end

    context "when stderr is not a TTY" do
      it "must not highlight the exception" do
        subject.print_exception(exception)

        expect(subject.stderr.string).to eq(
          exception.full_message(highlight: false)
        )
      end
    end
  end
end
