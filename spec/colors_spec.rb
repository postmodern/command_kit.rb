require 'spec_helper'
require 'command_kit/colors'

describe CommandKit::Colors do
  module TestColors
    class TestCommand
      include CommandKit::Colors
    end
  end

  let(:command_class) { TestColors::TestCommand }
  subject { command_class.new }

  it { expect(described_class).to include(CommandKit::Stdio) }
  it { expect(described_class).to include(CommandKit::Env) }

  describe CommandKit::Colors::ANSI do
    subject { described_class }

    describe "RESET" do
      it { expect(subject::RESET).to eq("\e[0m") }
    end

    describe "CLEAR" do
      it { expect(subject::CLEAR).to eq("\e[0m") }
    end

    describe "BOLD" do
      it { expect(subject::BOLD).to eq("\e[1m") }
    end

    describe "RESET_INTENSITY" do
      it { expect(subject::RESET_INTENSITY).to eq("\e[22m") }
    end

    describe "BLACK" do
      it { expect(subject::BLACK).to eq("\e[30m") }
    end

    describe "RED" do
      it { expect(subject::RED).to eq("\e[31m") }
    end

    describe "GREEN" do
      it { expect(subject::GREEN).to eq("\e[32m") }
    end

    describe "YELLOW" do
      it { expect(subject::YELLOW).to eq("\e[33m") }
    end

    describe "BLUE" do
      it { expect(subject::BLUE).to eq("\e[34m") }
    end

    describe "MAGENTA" do
      it { expect(subject::MAGENTA).to eq("\e[35m") }
    end

    describe "CYAN" do
      it { expect(subject::CYAN).to eq("\e[36m") }
    end

    describe "WHITE" do
      it { expect(subject::WHITE).to eq("\e[37m") }
    end

    describe "BG_BLACK" do
      it { expect(subject::BG_BLACK).to eq("\e[40m") }
    end

    describe "BG_RED" do
      it { expect(subject::BG_RED).to eq("\e[41m") }
    end

    describe "BG_GREEN" do
      it { expect(subject::BG_GREEN).to eq("\e[42m") }
    end

    describe "BG_YELLOW" do
      it { expect(subject::BG_YELLOW).to eq("\e[43m") }
    end

    describe "BG_BLUE" do
      it { expect(subject::BG_BLUE).to eq("\e[44m") }
    end

    describe "BG_MAGENTA" do
      it { expect(subject::BG_MAGENTA).to eq("\e[45m") }
    end

    describe "BG_CYAN" do
      it { expect(subject::BG_CYAN).to eq("\e[46m") }
    end

    describe "BG_WHITE" do
      it { expect(subject::BG_WHITE).to eq("\e[47m") }
    end

    describe "RESET_COLOR" do
      it { expect(subject::RESET_COLOR).to eq("\e[39m") }
    end

    let(:str) { 'foo' }

    describe ".reset" do
      it { expect(subject.reset).to eq(described_class::RESET) }
    end

    describe ".clear" do
      it { expect(subject.clear).to eq(described_class::CLEAR) }
    end

    describe ".bold" do
      context "when given a string" do
        it "must wrap the string with \\e[1m and \\e[22m" do
          expect(subject.bold(str)).to eq("\e[1m#{str}\e[22m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bold).to eq("\e[1m") }
      end
    end

    describe ".black" do
      context "when given a string" do
        it "must wrap the string with \\e[30m and \\e[39m" do
          expect(subject.black(str)).to eq("\e[30m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.black).to eq("\e[30m") }
      end
    end

    describe ".red" do
      context "when given a string" do
        it "must wrap the string with \\e[31m and \\e[39m" do
          expect(subject.red(str)).to eq("\e[31m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.red).to eq("\e[31m") }
      end
    end

    describe ".green" do
      context "when given a string" do
        it "must wrap the string with \\e[32m and \\e[39m" do
          expect(subject.green(str)).to eq("\e[32m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.green).to eq("\e[32m") }
      end
    end

    describe ".yellow" do
      context "when given a string" do
        it "must wrap the string with \\e[33m and \\e[39m" do
          expect(subject.yellow(str)).to eq("\e[33m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.yellow).to eq("\e[33m") }
      end
    end

    describe ".blue" do
      context "when given a string" do
        it "must wrap the string with \\e[34m and \\e[39m" do
          expect(subject.blue(str)).to eq("\e[34m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.blue).to eq("\e[34m") }
      end
    end

    describe ".magenta" do
      context "when given a string" do
        it "must wrap the string with \\e[35m and \\e[39m" do
          expect(subject.magenta(str)).to eq("\e[35m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.magenta).to eq("\e[35m") }
      end
    end

    describe ".cyan" do
      context "when given a string" do
        it "must wrap the string with \\e[36m and \\e[39m" do
          expect(subject.cyan(str)).to eq("\e[36m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.cyan).to eq("\e[36m") }
      end
    end

    describe ".white" do
      context "when given a string" do
        it "must wrap the string with \\e[37m and \\e[39m" do
          expect(subject.white(str)).to eq("\e[37m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.white).to eq("\e[37m") }
      end
    end

    describe ".bg_black" do
      context "when given a string" do
        it "must wrap the string with \\e[40m and \\e[39m" do
          expect(subject.bg_black(str)).to eq("\e[40m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_black).to eq("\e[40m") }
      end
    end

    describe ".bg_red" do
      context "when given a string" do
        it "must wrap the string with \\e[41m and \\e[39m" do
          expect(subject.bg_red(str)).to eq("\e[41m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_red).to eq("\e[41m") }
      end
    end

    describe ".bg_green" do
      context "when given a string" do
        it "must wrap the string with \\e[42m and \\e[39m" do
          expect(subject.bg_green(str)).to eq("\e[42m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_green).to eq("\e[42m") }
      end
    end

    describe ".bg_yellow" do
      context "when given a string" do
        it "must wrap the string with \\e[43m and \\e[39m" do
          expect(subject.bg_yellow(str)).to eq("\e[43m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_yellow).to eq("\e[43m") }
      end
    end

    describe ".bg_blue" do
      context "when given a string" do
        it "must wrap the string with \\e[44m and \\e[39m" do
          expect(subject.bg_blue(str)).to eq("\e[44m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_blue).to eq("\e[44m") }
      end
    end

    describe ".bg_magenta" do
      context "when given a string" do
        it "must wrap the string with \\e[45m and \\e[39m" do
          expect(subject.bg_magenta(str)).to eq("\e[45m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_magenta).to eq("\e[45m") }
      end
    end

    describe ".bg_cyan" do
      context "when given a string" do
        it "must wrap the string with \\e[46m and \\e[39m" do
          expect(subject.bg_cyan(str)).to eq("\e[46m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_cyan).to eq("\e[46m") }
      end
    end

    describe ".bg_white" do
      context "when given a string" do
        it "must wrap the string with \\e[47m and \\e[39m" do
          expect(subject.bg_white(str)).to eq("\e[47m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_white).to eq("\e[47m") }
      end
    end
  end

  describe CommandKit::Colors::PlainText do
    subject { described_class }

    let(:str) { 'foo' }

    describe "RESET" do
      it { expect(subject::RESET).to eq('') }
    end

    describe "CLEAR" do
      it { expect(subject::CLEAR).to eq('') }
    end

    describe "BOLD" do
      it { expect(subject::BOLD).to eq('') }
    end

    describe "RESET_INTENSITY" do
      it { expect(subject::RESET_INTENSITY).to eq('') }
    end

    describe "BLACK" do
      it { expect(subject::BLACK).to eq('') }
    end

    describe "RED" do
      it { expect(subject::RED).to eq('') }
    end

    describe "GREEN" do
      it { expect(subject::GREEN).to eq('') }
    end

    describe "YELLOW" do
      it { expect(subject::YELLOW).to eq('') }
    end

    describe "BLUE" do
      it { expect(subject::BLUE).to eq('') }
    end

    describe "MAGENTA" do
      it { expect(subject::MAGENTA).to eq('') }
    end

    describe "CYAN" do
      it { expect(subject::CYAN).to eq('') }
    end

    describe "WHITE" do
      it { expect(subject::WHITE).to eq('') }
    end

    describe "BG_BLACK" do
      it { expect(subject::BG_BLACK).to eq('') }
    end

    describe "BG_RED" do
      it { expect(subject::BG_RED).to eq('') }
    end

    describe "BG_GREEN" do
      it { expect(subject::BG_GREEN).to eq('') }
    end

    describe "BG_YELLOW" do
      it { expect(subject::BG_YELLOW).to eq('') }
    end

    describe "BG_BLUE" do
      it { expect(subject::BG_BLUE).to eq('') }
    end

    describe "BG_MAGENTA" do
      it { expect(subject::BG_MAGENTA).to eq('') }
    end

    describe "BG_CYAN" do
      it { expect(subject::BG_CYAN).to eq('') }
    end

    describe "BG_WHITE" do
      it { expect(subject::BG_WHITE).to eq('') }
    end

    describe "RESET_COLOR" do
      it { expect(subject::RESET_COLOR).to eq('') }
    end

    describe ".reset" do
      it { expect(subject.reset).to eq('') }
    end

    describe ".clear" do
      it { expect(subject.clear).to eq('') }
    end

    describe ".bold" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.bold(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bold).to eq('') }
      end
    end

    describe ".black" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.black(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.black).to eq('') }
      end
    end

    describe ".red" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.red(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.red).to eq('') }
      end
    end

    describe ".green" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.green(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.green).to eq('') }
      end
    end

    describe ".yellow" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.yellow(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.yellow).to eq('') }
      end
    end

    describe ".blue" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.blue(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.blue).to eq('') }
      end
    end

    describe ".magenta" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.magenta(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.magenta).to eq('') }
      end
    end

    describe ".cyan" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.cyan(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.cyan).to eq('') }
      end
    end

    describe ".white" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.white(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.white).to eq('') }
      end
    end

    describe ".bg_black" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.bg_black(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_black).to eq('') }
      end
    end

    describe ".bg_red" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.bg_red(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_red).to eq('') }
      end
    end

    describe ".bg_green" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.bg_green(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_green).to eq('') }
      end
    end

    describe ".bg_yellow" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.bg_yellow(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_yellow).to eq('') }
      end
    end

    describe ".bg_blue" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.bg_blue(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_blue).to eq('') }
      end
    end

    describe ".bg_magenta" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.bg_magenta(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_magenta).to eq('') }
      end
    end

    describe ".bg_cyan" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.bg_cyan(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_cyan).to eq('') }
      end
    end

    describe ".bg_white" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.bg_white(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bg_white).to eq('') }
      end
    end
  end

  describe "#ansi?" do
    context "when TERM='dumb'" do
      subject { command_class.new(env: {'TERM' => 'dumb'}) }

      it { expect(subject.ansi?).to be(false) }
    end

    context "when stdout is a TTY" do
      let(:stdout) { StringIO.new }
      subject { command_class.new(stdout: stdout) }

      before { allow(stdout).to receive(:tty?).and_return(true) }

      it { expect(subject.ansi?).to be(true) }
    end

    context "when stdout is not a TTY" do
      let(:stdout) { StringIO.new }
      subject { command_class.new(stdout: stdout) }

      it { expect(subject.ansi?).to be(false) }
    end

    context "when given an alternate stream" do
      context "and the alternate stream is a TTY" do
        let(:stream) { StringIO.new }

        before { allow(stream).to receive(:tty?).and_return(true) }

        it { expect(subject.ansi?(stream)).to be(true) }
      end

      context "but the alternate stream is not a TTY" do
        let(:stream) { StringIO.new }

        it { expect(subject.ansi?(stream)).to be(false) }
      end
    end
  end

  describe "#colors" do
    context "when stdout supports ANSI" do
      let(:stdout) { StringIO.new }
      subject { command_class.new(stdout: stdout) }

      before { allow(stdout).to receive(:tty?).and_return(true) }

      it do
        expect(subject.colors).to be(described_class::ANSI)
      end

      context "when a block is given" do
        it do
          expect { |b|
            subject.colors(&b)
          }.to yield_with_args(described_class::ANSI)
        end
      end
    end

    context "when stdout does not support ANSI" do
      let(:stdout) { StringIO.new }
      subject { command_class.new(stdout: stdout) }

      it do
        expect(subject.colors).to be(described_class::PlainText)
      end

      context "when a block is given" do
        it do
          expect { |b|
            subject.colors(&b)
          }.to yield_with_args(described_class::PlainText)
        end
      end
    end

    context "when given an alternate stream" do
      context "and the alternate stream supports ANSI" do
        let(:stream) { StringIO.new }

        before { allow(stream).to receive(:tty?).and_return(true) }

        it do
          expect(subject.colors(stream)).to be(described_class::ANSI)
        end

        context "when a block is given" do
          it do
            expect { |b|
              subject.colors(stream,&b)
            }.to yield_with_args(described_class::ANSI)
          end
        end
      end

      context "but the alternate stream does not support ANSI" do
        let(:stream) { StringIO.new }

        it do
          expect(subject.colors(stream)).to be(described_class::PlainText)
        end

        context "when a block is given" do
          it do
            expect { |b|
              subject.colors(stream,&b)
            }.to yield_with_args(described_class::PlainText)
          end
        end
      end
    end
  end
end
