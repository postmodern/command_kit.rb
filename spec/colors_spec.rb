require 'spec_helper'
require 'command_kit/colors'

describe Colors do
  module TestColors
    class TestCommand
      include CommandKit::Colors
    end
  end

  let(:command_class) { TestColors::TestCommand }
  subject { command_class.new }

  it { expect(described_class).to include(Stdio) }
  it { expect(described_class).to include(Env) }

  describe Colors::ANSI do
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
  end

  describe Colors::PlainText do
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

      it { expect(subject.colors).to be(Colors::ANSI) }

      context "when a block is given" do
        it do
          expect { |b|
            subject.colors(&b)
          }.to yield_with_args(Colors::ANSI)
        end
      end
    end

    context "when stdout does not support ANSI" do
      let(:stdout) { StringIO.new }
      subject { command_class.new(stdout: stdout) }

      it { expect(subject.colors).to be(Colors::PlainText) }

      context "when a block is given" do
        it do
          expect { |b|
            subject.colors(&b)
          }.to yield_with_args(Colors::PlainText)
        end
      end
    end

    context "when given an alternate stream" do
      context "and the alternate stream supports ANSI" do
        let(:stream) { StringIO.new }

        before { allow(stream).to receive(:tty?).and_return(true) }

        it { expect(subject.colors(stream)).to be(Colors::ANSI) }

        context "when a block is given" do
          it do
            expect { |b|
              subject.colors(stream,&b)
            }.to yield_with_args(Colors::ANSI)
          end
        end
      end

      context "but the alternate stream does not support ANSI" do
        let(:stream) { StringIO.new }

        it { expect(subject.colors(stream)).to be(Colors::PlainText) }

        context "when a block is given" do
          it do
            expect { |b|
              subject.colors(stream,&b)
            }.to yield_with_args(Colors::PlainText)
          end
        end
      end
    end
  end
end
