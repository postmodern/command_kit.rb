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

  describe "#ansi?" do
    context "when TERM='dumb'" do
      subject { command_class.new(env: {'TERM' => 'dumb'}) }

      it { expect(subject.ansi?).to be(false) }
    end

    context "when NO_COLOR is set" do
      subject { command_class.new(env: {'NO_COLOR' => 'true'}) }

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
