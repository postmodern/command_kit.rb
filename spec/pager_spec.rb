require 'spec_helper'
require 'command_kit/pager'

require 'stringio'

describe CommandKit::Pager do
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

      it "must set @pager_command to the PAGER env variable" do
        expect(subject.instance_variable_get('@pager_command')).to eq(pager)
      end
    end

    context "when the PAGER env variable is not set" do
      context "but the PATH env variable is" do
        subject { command_class.new(env: {'PATH' => ENV.fetch('PATH')}) }

        it "must search PATH for one of the pagers" do
          expect(subject.instance_variable_get('@pager_command')).to eq("less -r")
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

    context "when @pager_command isn't initialized" do
      before do
        subject.instance_variable_set('@pager_command',nil)
      end

      it "must yield stdout" do
        expect { |b|
          subject.pager(&b)
        }.to yield_with_args(subject.stdout)
      end
    end

    context "when stdout is a TTY and @pager_command is initialized" do
      let(:pager) { 'less -r' }

      subject { command_class.new(env: {'PAGER' => pager}) }

      let(:pager_io)  { double('less') }
      let(:pager_pid) { double('pid')  }

      before do
        expect(subject.stdout).to receive(:tty?).and_return(true)

        expect(IO).to receive(:popen).with(pager,'w').and_return(pager_io)
        expect(pager_io).to receive(:pid).and_return(pager_pid)

        expect(pager_io).to receive(:close)
        expect(Process).to receive(:waitpid).with(pager_pid)
      end

      it "must spawn a new process and yield an IO object" do
        expect { |b|
          subject.pager(&b)
        }.to yield_with_args(pager_io)
      end

      context "when Errno::EPIPE is raised" do
        it "must return gracefully" do
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
    let(:terminal_height) { 10 }

    before do
      expect(subject).to receive(:terminal_height).and_return(terminal_height)
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
        let(:string) { "foo#{$/}bar#{$/}" * terminal_height }

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
        let(:array) { ['foo', 'bar'] * terminal_height }

        it "must spawn a pager and puts the Array of Strings to the pager" do
          pager = double('pager')
          expect(subject).to receive(:pager).and_yield(pager)
          expect(pager).to receive(:puts).with(array)

          subject.print_or_page(array)
        end
      end
    end
  end

  describe "#pipe_to_pager" do
    context "when @pager_command is initialized" do
      let(:pager) { 'less' }

      subject do
        command_class.new(env: {'PAGER' => pager})
      end

      context "and when given a single String" do
        let(:command) { "find ." }

        it "must run the command but piped into the pager" do
          expect(subject).to receive(:system).with("#{command} | #{pager}")

          subject.pipe_to_pager(command)
        end
      end

      context "and when given a String and additional arguments" do
        let(:command)   { 'find'          }
        let(:arguments) { %w[. -name *.md] }

        let(:escaped_command) do
          Shellwords.shelljoin([command,*arguments])
        end

        it "must shell escape the command and arguments" do
          expect(subject).to receive(:system).with(
            "#{escaped_command} | #{pager}"
          )

          subject.pipe_to_pager(command,*arguments)
        end
      end
    end

    context "when @pager_command is not initialized" do
      before do
        subject.instance_variable_set('@pager_command',nil)
      end

      let(:command)   { 'find' }
      let(:arguments) { %w[. -name *.md] }

      it "must pass the command and any additional arguments to #system" do
        expect(subject).to receive(:system).with(command,*arguments)

        subject.pipe_to_pager(command,*arguments)
      end

      context "when one of the arguments is not a String" do
        let(:command)   { :find }
        let(:arguments) { ['.', :"-name", "*.md"] }

        it "must convert the command to a String before calling #system" do
          expect(subject).to receive(:system).with(
            command.to_s, *arguments.map(&:to_s)
          )

          subject.pipe_to_pager(command,*arguments)
        end
      end
    end
  end
end
