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

    context "when IO.console is missing" do
      before do
        expect(IO).to receive(:respond_to?).with(:console).and_return(false)
      end

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

    context "when IO.console is missing" do
      before do
        expect(IO).to receive(:respond_to?).with(:console).and_return(false)
      end

      it do
        expect(subject.console).to be(nil)
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

      it "must fallback to DEFAULT_HEIGHT" do
        expect(subject.console_height).to eq(described_class::DEFAULT_HEIGHT)
      end

      context "but the LINES env variable was set" do
        let(:lines) { 10 }
        let(:env)   { {'LINES' => lines.to_s} }

        subject { command_class.new(stdout: StringIO.new, env: env) }

        it "must fallback to the LINES environment variable" do
          expect(subject.console_height).to eq(lines)
        end
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

      it "must fallback to DEFAULT_WIDTH" do
        expect(subject.console_width).to eq(described_class::DEFAULT_WIDTH)
      end

      context "but the COLUMNS env variable was set" do
        let(:columns) { 50 }
        let(:env)     { {'COLUMNS' => columns.to_s} }

        subject { command_class.new(stdout: StringIO.new, env: env) }

        it "must fallback to the COLUMNS environment variable" do
          expect(subject.console_width).to eq(columns)
        end
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

      it "must fallback to [DEFAULT_HEIGHT, DEFAULT_WIDTH]" do
        expect(subject.console_size).to eq(
          [described_class::DEFAULT_HEIGHT, described_class::DEFAULT_WIDTH]
        )
      end

      context "but the LINES env variable was set" do
        let(:lines) { 10 }
        let(:env)   { {'LINES' => lines.to_s} }

        subject { command_class.new(stdout: StringIO.new, env: env) }

        it "must fallback to the [$LINES, DEFAULT_WIDTH]" do
          expect(subject.console_size).to eq(
            [lines, described_class::DEFAULT_WIDTH]
          )
        end
      end

      context "but the COLUMNS env variable was set" do
        let(:columns) { 50 }
        let(:env)     { {'COLUMNS' => columns.to_s} }

        subject { command_class.new(stdout: StringIO.new, env: env) }

        it "must fallback to the [DEFAULT_HEIGHT, COLUMNS]" do
          expect(subject.console_size).to eq(
            [described_class::DEFAULT_HEIGHT, columns]
          )
        end
      end

      context "but the LINES and COLUMNS env variable was set" do
        let(:lines) { 10 }
        let(:columns) { 50 }
        let(:env) do
          {'LINES' => lines.to_s, 'COLUMNS' => columns.to_s}
        end

        subject { command_class.new(stdout: StringIO.new, env: env) }

        it "must fallback to the [LINES, COLUMNS]" do
          expect(subject.console_size).to eq(
            [lines, columns]
          )
        end
      end
    end
  end
end
