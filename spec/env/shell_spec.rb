require 'spec_helper'
require 'command_kit/env/shell'

describe CommandKit::Env::Shell do
  module TestEnvShell
    class TestCommand
      include CommandKit::Env::Shell
    end
  end

  let(:command_class) { TestEnvShell::TestCommand }

  let(:shell) { '/bin/bash' }

  subject do
    command_class.new(env: {'SHELL' => shell})
  end

  describe "#shell" do
    context "when env['SHELL'] is set" do
      it "must set #shell to env['SHELL']" do
        expect(subject.shell).to eq(shell)
      end
    end

    context "when env['SHELL'] is not set" do
      subject { command_class.new(env: {}) }

      it "must set #shell to nil" do
        expect(subject.shell).to be(nil)
      end
    end
  end

  describe "#shell_type" do
    context "when env['SHELL'] is set" do
      context "when filename of the shell is 'bash'" do
        let(:shell) { '/bin/bash' }

        it "must set #shell_type to :bash" do
          expect(subject.shell_type).to eq(:bash)
        end
      end

      context "when filename of the shell contains 'bash'" do
        let(:shell) { '/bin/bash-1.23' }

        it "must set #shell_type to :bash" do
          expect(subject.shell_type).to eq(:bash)
        end
      end

      context "when filename of the shell is 'zsh'" do
        let(:shell) { '/bin/zsh' }

        it "must set #shell_type to :zsh" do
          expect(subject.shell_type).to eq(:zsh)
        end
      end

      context "when filename of the shell contains 'zsh'" do
        let(:shell) { '/bin/zsh-1.23' }

        it "must set #shell_type to :zsh" do
          expect(subject.shell_type).to eq(:zsh)
        end
      end

      context "when filename of the shell is 'fish'" do
        let(:shell) { '/bin/fish' }

        it "must set #shell_type to :fish" do
          expect(subject.shell_type).to eq(:fish)
        end
      end

      context "when filename of the shell contains 'fish'" do
        let(:shell) { '/bin/fish-1.23' }

        it "must set #shell_type to :fish" do
          expect(subject.shell_type).to eq(:fish)
        end
      end

      context "when filename of the shell is 'dash'" do
        let(:shell) { '/bin/dash' }

        it "must set #shell_type to :dash" do
          expect(subject.shell_type).to eq(:dash)
        end
      end

      context "when filename of the shell contains 'dash'" do
        let(:shell) { '/bin/dash-1.23' }

        it "must set #shell_type to :dash" do
          expect(subject.shell_type).to eq(:dash)
        end
      end

      context "when filename of the shell is 'mksh'" do
        let(:shell) { '/bin/mksh' }

        it "must set #shell_type to :mksh" do
          expect(subject.shell_type).to eq(:mksh)
        end
      end

      context "when filename of the shell contains 'mksh'" do
        let(:shell) { '/bin/mksh-1.23' }

        it "must set #shell_type to :mksh" do
          expect(subject.shell_type).to eq(:mksh)
        end
      end

      context "when filename of the shell is 'ksh'" do
        let(:shell) { '/bin/ksh' }

        it "must set #shell_type to :ksh" do
          expect(subject.shell_type).to eq(:ksh)
        end
      end

      context "when filename of the shell contains 'ksh'" do
        let(:shell) { '/bin/ksh-1.23' }

        it "must set #shell_type to :ksh" do
          expect(subject.shell_type).to eq(:ksh)
        end
      end

      context "when filename of the shell is 'tcsh'" do
        let(:shell) { '/bin/tcsh' }

        it "must set #shell_type to :tcsh" do
          expect(subject.shell_type).to eq(:tcsh)
        end
      end

      context "when filename of the shell contains 'tcsh'" do
        let(:shell) { '/bin/tcsh-1.23' }

        it "must set #shell_type to :tcsh" do
          expect(subject.shell_type).to eq(:tcsh)
        end
      end

      context "when filename of the shell is 'csh'" do
        let(:shell) { '/bin/csh' }

        it "must set #shell_type to :csh" do
          expect(subject.shell_type).to eq(:csh)
        end
      end

      context "when filename of the shell contains 'csh'" do
        let(:shell) { '/bin/csh-1.23' }

        it "must set #shell_type to :csh" do
          expect(subject.shell_type).to eq(:csh)
        end
      end

      context "when filename of the shell is 'sh'" do
        let(:shell) { '/bin/sh' }

        it "must set #shell_type to :sh" do
          expect(subject.shell_type).to eq(:sh)
        end
      end

      context "when filename of the shell contains 'sh'" do
        let(:shell) { '/bin/sh-1.23' }

        it "must set #shell_type to :sh" do
          expect(subject.shell_type).to eq(:sh)
        end
      end

      context "when env['SHELL'] is unrecognized" do
        let(:shell) { '/bin/foo' }

        it "must set #shell_type to nil" do
          expect(subject.shell_type).to eq(nil)
        end
      end
    end

    context "when env['SHELL'] is not set" do
      subject { command_class.new(env: {}) }

      it "must set #shell_type to nil" do
        expect(subject.shell_type).to be(nil)
      end
    end
  end
end
