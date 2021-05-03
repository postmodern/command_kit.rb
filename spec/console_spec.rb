require 'spec_helper'
require 'command_kit/console'

require 'stringio'

describe Console do
  module TestConsole
    class TestCommand
      include CommandKit::Console
    end
  end

  let(:command_class) { TestConsole::TestCommand }
  subject { command_class.new }

  describe "#console?" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.console?).to be(true)
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it do
        expect(subject.console?).to be(false)
      end
    end
  end

  describe "#console" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.console).to eq(IO.console)
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it do
        expect(subject.console).to eq(nil)
      end
    end
  end

  describe "#console_size" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.console_size).to eq(STDOUT.winsize)
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it do
        expect(subject.console_size).to eq(nil)
      end
    end
  end

  describe "#console_height" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.console_height).to eq(STDOUT.winsize[0])
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it do
        expect(subject.console_height).to eq(nil)
      end
    end
  end

  describe "#console_width" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.console_width).to eq(STDOUT.winsize[1])
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it do
        expect(subject.console_width).to eq(nil)
      end
    end
  end
end
