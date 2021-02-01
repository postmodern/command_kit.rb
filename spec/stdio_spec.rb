require 'spec_helper'
require 'command_kit/stdio'

describe CommandKit::Stdio do
  module TestStdio
    class TestCommand
      include CommandKit::Stdio
    end
  end

  let(:command_class) { TestStdio::TestCommand }

  describe "#initialize" do
    module TestStdio
      class TestCommandWithInitialize
        include CommandKit::Stdio

        attr_reader :var

        def initialize
          @var = 'foo'
        end
      end

      class TestCommandWithInitializeAndKeywordArgs
        include CommandKit::Stdio

        attr_reader :var

        def initialize(var: "foo")
          @var = var
        end
      end
    end

    context "when given no arguments" do
      subject { command_class.new() }

      it "must initialize #stdin to $stdin" do
        expect(subject.stdin).to be($stdin)
      end

      it "must initialize #stdout to $stdout" do
        expect(subject.stdout).to be($stdout)
      end

      it "must initialize #stderr to $stderr" do
        expect(subject.stderr).to be($stderr)
      end

      context "and the including class defines it's own #initialize method" do
        let(:command_class) { TestStdio::TestCommandWithInitialize }

        it "must initialize #stdin to $stdin" do
          expect(subject.stdin).to be($stdin)
        end

        it "must initialize #stdout to $stdout" do
          expect(subject.stdout).to be($stdout)
        end

        it "must initialize #stderr to $stderr" do
          expect(subject.stderr).to be($stderr)
        end

        it "must also call the class'es #initialize method" do
          expect(subject.var).to eq('foo')
        end

        context "and it accepts keyword arguments" do
          let(:command_class) { TestStdio::TestCommandWithInitializeAndKeywordArgs }
          let(:var) { 'custom value' }

          subject { command_class.new(var: var) }

          it "must initialize #stdin to $stdin" do
            expect(subject.stdin).to be($stdin)
          end

          it "must initialize #stdout to $stdout" do
            expect(subject.stdout).to be($stdout)
          end

          it "must initialize #stderr to $stderr" do
            expect(subject.stderr).to be($stderr)
          end

          it "must also call the class'es #initialize method with any additional keyword arguments" do
            expect(subject.var).to eq(var)
          end
        end
      end
    end

    context "when given a custom env: value" do
      let(:custom_stdin)  { StringIO.new }
      let(:custom_stdout) { StringIO.new }
      let(:custom_stderr) { StringIO.new }

      subject do
        command_class.new(
          stdin: custom_stdin,
          stdout: custom_stdout,
          stderr: custom_stderr
        )
      end

      it "must initialize #stdin to the stdin: value" do
        expect(subject.stdin).to eq(custom_stdin)
      end

      it "must initialize #stdout to the stdout: value" do
        expect(subject.stdout).to eq(custom_stdout)
      end

      it "must initialize #stderr to the stderr: value" do
        expect(subject.stderr).to eq(custom_stderr)
      end

      context "and the including class defines it's own #initialize method" do
        let(:command_class) { TestStdio::TestCommandWithInitialize }

        it "must initialize #stdin to the stdin: value" do
          expect(subject.stdin).to eq(custom_stdin)
        end

        it "must initialize #stdout to the stdout: value" do
          expect(subject.stdout).to eq(custom_stdout)
        end

        it "must initialize #stderr to the stderr: value" do
          expect(subject.stderr).to eq(custom_stderr)
        end

        it "must also call the class'es #initialize method" do
          expect(subject.var).to eq('foo')
        end

        context "and it accepts keyword arguments" do
          let(:command_class) { TestStdio::TestCommandWithInitializeAndKeywordArgs }
          let(:var) { 'custom value' }

          subject do
            command_class.new(
              stdin:  custom_stdin,
              stdout: custom_stdout,
              stderr: custom_stderr,
              var: var
            )
          end

          it "must initialize #stdin to the stdin: value" do
            expect(subject.stdin).to eq(custom_stdin)
          end

          it "must initialize #stdout to the stdout: value" do
            expect(subject.stdout).to eq(custom_stdout)
          end

          it "must initialize #stderr to the stderr: value" do
            expect(subject.stderr).to eq(custom_stderr)
          end

          it "must also call the class'es #initialize method with any additional keyword arguments" do
            expect(subject.var).to eq(var)
          end
        end
      end
    end
  end

  describe "#stdin" do
    let(:command_class) { TestStdio::TestCommand }
    let(:stdin) { StringIO.new }

    subject { command_class.new(stdin: stdin) }

    it "must return the initialized stdin: value" do
      expect(subject.stdin).to eq(stdin)
    end
  end

  describe "#stdout" do
    let(:command_class) { TestStdio::TestCommand }
    let(:stdout) { StringIO.new }

    subject { command_class.new(stdout: stdout) }

    it "must return the initialized stdout: value" do
      expect(subject.stdout).to eq(stdout)
    end
  end

  describe "#stderr" do
    let(:command_class) { TestStdio::TestCommand }
    let(:stderr) { StringIO.new }

    subject { command_class.new(stderr: stderr) }

    it "must return the initialized stderr: value" do
      expect(subject.stderr).to eq(stderr)
    end
  end
end