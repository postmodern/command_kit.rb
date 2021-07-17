require 'spec_helper'
require 'command_kit/terminal'

require 'stringio'

describe CommandKit::Terminal do
  module TestTerminal
    class TestCommand
      include CommandKit::Terminal
    end
  end

  let(:command_class) { TestTerminal::TestCommand }
  subject { command_class.new }

  describe "#terminal?" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.terminal?).to be(true)
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it do
        expect(subject.terminal?).to be(false)
      end
    end

    context "when IO.console is missing" do
      before do
        expect(IO).to receive(:respond_to?).with(:console).and_return(false)
      end

      it do
        expect(subject.terminal?).to be(false)
      end
    end
  end

  describe "#tty?" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.tty?).to be(true)
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it do
        expect(subject.tty?).to be(false)
      end
    end

    context "when IO.console is missing" do
      before do
        expect(IO).to receive(:respond_to?).with(:console).and_return(false)
      end

      it do
        expect(subject.tty?).to be(false)
      end
    end
  end

  describe "#terminal" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.terminal).to eq(IO.console)
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it do
        expect(subject.terminal).to eq(nil)
      end
    end

    context "when IO.console is missing" do
      before do
        expect(IO).to receive(:respond_to?).with(:console).and_return(false)
      end

      it do
        expect(subject.terminal).to be(nil)
      end
    end
  end

  describe "#terminal_height" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.terminal_height).to eq(STDOUT.winsize[0])
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it "must fallback to DEFAULT_TERMINAL_HEIGHT" do
        expect(subject.terminal_height).to eq(described_class::DEFAULT_TERMINAL_HEIGHT)
      end

      context "but the LINES env variable was set" do
        let(:lines) { 10 }
        let(:env)   { {'LINES' => lines.to_s} }

        subject { command_class.new(stdout: StringIO.new, env: env) }

        it "must fallback to the LINES environment variable" do
          expect(subject.terminal_height).to eq(lines)
        end
      end
    end
  end

  describe "#terminal_width" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.terminal_width).to eq(STDOUT.winsize[1])
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it "must fallback to DEFAULT_TERMINAL_WIDTH" do
        expect(subject.terminal_width).to eq(described_class::DEFAULT_TERMINAL_WIDTH)
      end

      context "but the COLUMNS env variable was set" do
        let(:columns) { 50 }
        let(:env)     { {'COLUMNS' => columns.to_s} }

        subject { command_class.new(stdout: StringIO.new, env: env) }

        it "must fallback to the COLUMNS environment variable" do
          expect(subject.terminal_width).to eq(columns)
        end
      end
    end
  end

  describe "#terminal_size" do
    context "when stdout is connected to a TTY" do
      subject { command_class.new(stdout: STDOUT) }

      it do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect(subject.terminal_size).to eq(STDOUT.winsize)
      end
    end

    context "when stdout is not connected to a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it "must fallback to [DEFAULT_TERMINAL_HEIGHT, DEFAULT_TERMINAL_WIDTH]" do
        expect(subject.terminal_size).to eq(
          [described_class::DEFAULT_TERMINAL_HEIGHT, described_class::DEFAULT_TERMINAL_WIDTH]
        )
      end

      context "but the LINES env variable was set" do
        let(:lines) { 10 }
        let(:env)   { {'LINES' => lines.to_s} }

        subject { command_class.new(stdout: StringIO.new, env: env) }

        it "must fallback to the [$LINES, DEFAULT_TERMINAL_WIDTH]" do
          expect(subject.terminal_size).to eq(
            [lines, described_class::DEFAULT_TERMINAL_WIDTH]
          )
        end
      end

      context "but the COLUMNS env variable was set" do
        let(:columns) { 50 }
        let(:env)     { {'COLUMNS' => columns.to_s} }

        subject { command_class.new(stdout: StringIO.new, env: env) }

        it "must fallback to the [DEFAULT_TERMINAL_HEIGHT, COLUMNS]" do
          expect(subject.terminal_size).to eq(
            [described_class::DEFAULT_TERMINAL_HEIGHT, columns]
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
          expect(subject.terminal_size).to eq(
            [lines, columns]
          )
        end
      end
    end
  end
end
