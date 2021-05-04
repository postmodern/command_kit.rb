require 'spec_helper'
require 'command_kit/pager'

require 'stringio'

describe Pager do
  module TestPager
    class TestCommand
      include CommandKit::Pager
    end
  end

  let(:command_class) { TestPager::TestCommand }
  subject { command_class.new }

  describe "#initialize" do
    context "when the PAGER env variable is set" do
      let(:pager) { 'foo' }

      subject { command_class.new(env: {'PAGER' => pager}) }

      it "must set @pager to the PAGER env variable" do
        expect(subject.instance_variable_get('@pager')).to eq(pager)
      end
    end

    context "when the PAGER env variable is not set" do
      context "but the PATH env variable is" do
        subject { command_class.new(env: {'PATH' => ENV['PATH']}) }

        it "must search PATH for one of the pagers" do
          expect(subject.instance_variable_get('@pager')).to eq("less -r")
        end
      end
    end
  end

  describe "#pager" do
    context "when stdout is not a TTY" do
      subject { command_class.new(stdout: StringIO.new) }

      it "must yield stdout" do
        expect { |b|
          subject.pager(&b)
        }.to yield_with_args(subject.stdout)
      end
    end

    context "when @pager isn't initialized" do
      before do
        subject.instance_variable_set('@pager',nil)
      end

      it "must yield stdout" do
        expect { |b|
          subject.pager(&b)
        }.to yield_with_args(subject.stdout)
      end
    end

    context "when stdout is a TTY and @pager is initialized" do
      let(:pager) { 'less -r' }

      subject { command_class.new(env: {'PAGER' => pager}) }

      let(:pager_io)  { double('less') }
      let(:pager_pid) { double('pid')  }

      before do
        expect(IO).to receive(:popen).with(pager,'w').and_return(pager_io)
        expect(pager_io).to receive(:pid).and_return(pager_pid)

        expect(pager_io).to receive(:close)
        expect(Process).to receive(:waitpid).with(pager_pid)
      end

      it "must spawn a new process and yield an IO object" do
        skip "STDOUT is not a TTY" unless STDOUT.tty?

        expect { |b|
          subject.pager(&b)
        }.to yield_with_args(pager_io)
      end

      context "when Errno::EPIPE is raised" do
        it "must return gracefully" do
          skip "STDOUT is not a TTY" unless STDOUT.tty?

          expect {
            subject.pager do
              raise(Errno::EPIPE,"pipe broken")
            end
          }.to_not raise_error
        end
      end
    end
  end

  describe "#print_or_page" do
    let(:console_height) { 10 }

    before do
      expect(subject).to receive(:console_height).and_return(console_height)
    end

    context "when given a String" do
      context "and the number of lines is less than the console's height" do
        let(:string) { "foo#{$/}bar#{$/}" }

        it "must puts the String to stdout" do
          expect(subject.stdout).to receive(:puts).with(string)

          subject.print_or_page(string)
        end
      end

      context "and the number of lines is greater than the console's height" do
        let(:string) { "foo#{$/}bar#{$/}" * console_height }

        it "must spawn a pager and puts the String to the pager" do
          pager = double('pager')
          expect(subject).to receive(:pager).and_yield(pager)
          expect(pager).to receive(:puts).with(string)

          subject.print_or_page(string)
        end
      end
    end

    context "when given an Array" do
      context "and the number of lines is less than the console's height" do
        let(:array) { ['foo', 'bar'] }

        it "must puts the Array of Strings to stdout" do
          expect(subject.stdout).to receive(:puts).with(array)

          subject.print_or_page(array)
        end
      end

      context "and the number of lines is greater than the console's height" do
        let(:array) { ['foo', 'bar'] * console_height }

        it "must spawn a pager and puts the Array of Strings to the pager" do
          pager = double('pager')
          expect(subject).to receive(:pager).and_yield(pager)
          expect(pager).to receive(:puts).with(array)

          subject.print_or_page(array)
        end
      end
    end
  end
end
