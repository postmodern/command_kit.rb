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

    describe "BRIGHT_BLACK" do
      it { expect(subject::BRIGHT_BLACK).to eq("\e[90m") }
    end

    describe "BRIGHT_RED" do
      it { expect(subject::BRIGHT_RED).to eq("\e[91m") }
    end

    describe "BRIGHT_GREEN" do
      it { expect(subject::BRIGHT_GREEN).to eq("\e[92m") }
    end

    describe "BRIGHT_YELLOW" do
      it { expect(subject::BRIGHT_YELLOW).to eq("\e[93m") }
    end

    describe "BRIGHT_BLUE" do
      it { expect(subject::BRIGHT_BLUE).to eq("\e[94m") }
    end

    describe "BRIGHT_MAGENTA" do
      it { expect(subject::BRIGHT_MAGENTA).to eq("\e[95m") }
    end

    describe "BRIGHT_CYAN" do
      it { expect(subject::BRIGHT_CYAN).to eq("\e[96m") }
    end

    describe "BRIGHT_WHITE" do
      it { expect(subject::BRIGHT_WHITE).to eq("\e[97m") }
    end

    describe "ON_BLACK" do
      it { expect(subject::ON_BLACK).to eq("\e[40m") }
    end

    describe "ON_RED" do
      it { expect(subject::ON_RED).to eq("\e[41m") }
    end

    describe "ON_GREEN" do
      it { expect(subject::ON_GREEN).to eq("\e[42m") }
    end

    describe "ON_YELLOW" do
      it { expect(subject::ON_YELLOW).to eq("\e[43m") }
    end

    describe "ON_BLUE" do
      it { expect(subject::ON_BLUE).to eq("\e[44m") }
    end

    describe "ON_MAGENTA" do
      it { expect(subject::ON_MAGENTA).to eq("\e[45m") }
    end

    describe "ON_CYAN" do
      it { expect(subject::ON_CYAN).to eq("\e[46m") }
    end

    describe "ON_WHITE" do
      it { expect(subject::ON_WHITE).to eq("\e[47m") }
    end

    describe "ON_BRIGHT_BLACK" do
      it { expect(subject::ON_BRIGHT_BLACK).to eq("\e[100m") }
    end

    describe "ON_BRIGHT_RED" do
      it { expect(subject::ON_BRIGHT_RED).to eq("\e[101m") }
    end

    describe "ON_BRIGHT_GREEN" do
      it { expect(subject::ON_BRIGHT_GREEN).to eq("\e[102m") }
    end

    describe "ON_BRIGHT_YELLOW" do
      it { expect(subject::ON_BRIGHT_YELLOW).to eq("\e[103m") }
    end

    describe "ON_BRIGHT_BLUE" do
      it { expect(subject::ON_BRIGHT_BLUE).to eq("\e[104m") }
    end

    describe "ON_BRIGHT_MAGENTA" do
      it { expect(subject::ON_BRIGHT_MAGENTA).to eq("\e[105m") }
    end

    describe "ON_BRIGHT_CYAN" do
      it { expect(subject::ON_BRIGHT_CYAN).to eq("\e[106m") }
    end

    describe "ON_BRIGHT_WHITE" do
      it { expect(subject::ON_BRIGHT_WHITE).to eq("\e[107m") }
    end

    describe "RESET_FG" do
      it { expect(subject::RESET_FG).to eq("\e[39m") }
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

    describe ".bright_black" do
      context "when given a string" do
        it "must wrap the string with \\e[90m and \\e[39m" do
          expect(subject.bright_black(str)).to eq("\e[90m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bright_black).to eq("\e[90m") }
      end
    end

    describe ".gray" do
      context "when given a string" do
        it "must wrap the string with \\e[90m and \\e[39m" do
          expect(subject.gray(str)).to eq("\e[90m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.gray).to eq("\e[90m") }
      end
    end

    describe ".bright_red" do
      context "when given a string" do
        it "must wrap the string with \\e[91m and \\e[39m" do
          expect(subject.bright_red(str)).to eq("\e[91m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bright_red).to eq("\e[91m") }
      end
    end

    describe ".bright_green" do
      context "when given a string" do
        it "must wrap the string with \\e[92m and \\e[39m" do
          expect(subject.bright_green(str)).to eq("\e[92m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bright_green).to eq("\e[92m") }
      end
    end

    describe ".bright_yellow" do
      context "when given a string" do
        it "must wrap the string with \\e[93m and \\e[39m" do
          expect(subject.bright_yellow(str)).to eq("\e[93m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bright_yellow).to eq("\e[93m") }
      end
    end

    describe ".bright_blue" do
      context "when given a string" do
        it "must wrap the string with \\e[94m and \\e[39m" do
          expect(subject.bright_blue(str)).to eq("\e[94m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bright_blue).to eq("\e[94m") }
      end
    end

    describe ".bright_magenta" do
      context "when given a string" do
        it "must wrap the string with \\e[95m and \\e[39m" do
          expect(subject.bright_magenta(str)).to eq("\e[95m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bright_magenta).to eq("\e[95m") }
      end
    end

    describe ".bright_cyan" do
      context "when given a string" do
        it "must wrap the string with \\e[96m and \\e[39m" do
          expect(subject.bright_cyan(str)).to eq("\e[96m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bright_cyan).to eq("\e[96m") }
      end
    end

    describe ".bright_white" do
      context "when given a string" do
        it "must wrap the string with \\e[97m and \\e[39m" do
          expect(subject.bright_white(str)).to eq("\e[97m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bright_white).to eq("\e[97m") }
      end
    end

    describe ".on_black" do
      context "when given a string" do
        it "must wrap the string with \\e[40m and \\e[39m" do
          expect(subject.on_black(str)).to eq("\e[40m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_black).to eq("\e[40m") }
      end
    end

    describe ".on_red" do
      context "when given a string" do
        it "must wrap the string with \\e[41m and \\e[39m" do
          expect(subject.on_red(str)).to eq("\e[41m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_red).to eq("\e[41m") }
      end
    end

    describe ".on_green" do
      context "when given a string" do
        it "must wrap the string with \\e[42m and \\e[39m" do
          expect(subject.on_green(str)).to eq("\e[42m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_green).to eq("\e[42m") }
      end
    end

    describe ".on_yellow" do
      context "when given a string" do
        it "must wrap the string with \\e[43m and \\e[39m" do
          expect(subject.on_yellow(str)).to eq("\e[43m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_yellow).to eq("\e[43m") }
      end
    end

    describe ".on_blue" do
      context "when given a string" do
        it "must wrap the string with \\e[44m and \\e[39m" do
          expect(subject.on_blue(str)).to eq("\e[44m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_blue).to eq("\e[44m") }
      end
    end

    describe ".on_magenta" do
      context "when given a string" do
        it "must wrap the string with \\e[45m and \\e[39m" do
          expect(subject.on_magenta(str)).to eq("\e[45m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_magenta).to eq("\e[45m") }
      end
    end

    describe ".on_cyan" do
      context "when given a string" do
        it "must wrap the string with \\e[46m and \\e[39m" do
          expect(subject.on_cyan(str)).to eq("\e[46m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_cyan).to eq("\e[46m") }
      end
    end

    describe ".on_white" do
      context "when given a string" do
        it "must wrap the string with \\e[47m and \\e[39m" do
          expect(subject.on_white(str)).to eq("\e[47m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_white).to eq("\e[47m") }
      end
    end

    describe ".on_bright_black" do
      context "when given a string" do
        it "must wrap the string with \\e[100m and \\e[39m" do
          expect(subject.on_bright_black(str)).to eq("\e[100m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_bright_black).to eq("\e[100m") }
      end
    end

    describe ".on_gray" do
      context "when given a string" do
        it "must wrap the string with \\e[100m and \\e[39m" do
          expect(subject.on_gray(str)).to eq("\e[100m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_gray).to eq("\e[100m") }
      end
    end

    describe ".on_bright_red" do
      context "when given a string" do
        it "must wrap the string with \\e[101m and \\e[39m" do
          expect(subject.on_bright_red(str)).to eq("\e[101m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_bright_red).to eq("\e[101m") }
      end
    end

    describe ".on_bright_green" do
      context "when given a string" do
        it "must wrap the string with \\e[102m and \\e[39m" do
          expect(subject.on_bright_green(str)).to eq("\e[102m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_bright_green).to eq("\e[102m") }
      end
    end

    describe ".on_bright_yellow" do
      context "when given a string" do
        it "must wrap the string with \\e[103m and \\e[39m" do
          expect(subject.on_bright_yellow(str)).to eq("\e[103m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_bright_yellow).to eq("\e[103m") }
      end
    end

    describe ".on_bright_blue" do
      context "when given a string" do
        it "must wrap the string with \\e[104m and \\e[39m" do
          expect(subject.on_bright_blue(str)).to eq("\e[104m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_bright_blue).to eq("\e[104m") }
      end
    end

    describe ".on_bright_magenta" do
      context "when given a string" do
        it "must wrap the string with \\e[105m and \\e[39m" do
          expect(subject.on_bright_magenta(str)).to eq("\e[105m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_bright_magenta).to eq("\e[105m") }
      end
    end

    describe ".on_bright_cyan" do
      context "when given a string" do
        it "must wrap the string with \\e[106m and \\e[39m" do
          expect(subject.on_bright_cyan(str)).to eq("\e[106m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_bright_cyan).to eq("\e[106m") }
      end
    end

    describe ".on_bright_white" do
      context "when given a string" do
        it "must wrap the string with \\e[107m and \\e[39m" do
          expect(subject.on_bright_white(str)).to eq("\e[107m#{str}\e[49m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.on_bright_white).to eq("\e[107m") }
      end
    end
  end

  describe CommandKit::Colors::PlainText do
    subject { described_class }

    let(:str) { 'foo' }

    [
      :RESET, :CLEAR,
      :BOLD, :RESET_INTENSITY,
      :BLACK, :RED, :GREEN, :YELLOW, :BLUE, :MAGENTA, :CYAN, :WHITE,
      :BRIGHT_BLACK, :BRIGHT_RED, :BRIGHT_GREEN, :BRIGHT_YELLOW, :BRIGHT_BLUE, :BRIGHT_MAGENTA, :BRIGHT_CYAN, :BRIGHT_WHITE,
      :RESET_FG, :RESET_COLOR,
      :ON_BLACK, :ON_RED, :ON_GREEN, :ON_YELLOW, :ON_BLUE, :ON_MAGENTA, :ON_CYAN, :ON_WHITE,
      :ON_BRIGHT_BLACK, :ON_BRIGHT_RED, :ON_BRIGHT_GREEN, :ON_BRIGHT_YELLOW, :ON_BRIGHT_BLUE, :ON_BRIGHT_MAGENTA, :ON_BRIGHT_CYAN, :ON_BRIGHT_WHITE,
      :RESET_BG
    ].each do |const_name|
      describe const_name.to_s do
        it { expect(subject.const_get(const_name)).to eq('') }
      end
    end

    describe ".reset" do
      it { expect(subject.reset).to eq('') }
    end

    describe ".clear" do
      it { expect(subject.clear).to eq('') }
    end

    [
      :bold,
      :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white,
      :bright_black, :gray, :bright_red, :bright_green, :bright_yellow, :bright_blue, :bright_magenta, :bright_cyan, :bright_white,
      :on_black, :on_red, :on_green, :on_yellow, :on_blue, :on_magenta, :on_cyan, :on_white,
      :on_bright_black, :on_gray, :on_bright_red, :on_bright_green, :on_bright_yellow, :on_bright_blue, :on_bright_magenta, :on_bright_cyan, :on_bright_white
    ].each do |method_name|
      describe ".#{method_name}" do
        context "when given a string" do
          it "must return that string" do
            expect(subject.send(method_name,str)).to eq(str)
          end
        end

        context "when given no arguments" do
          it { expect(subject.send(method_name)).to eq('') }
        end
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
