require 'spec_helper'
require 'command_kit/os'

describe CommandKit::OS do
  class TestOS
    include CommandKit::OS
  end

  subject { TestOS.new }

  describe "#linux?" do
    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      it { expect(subject.linux?).to be(true) }
    end

    context "when RUBY_PLATFORM does not contain 'linux'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.linux?).to be(false) }
    end
  end

  describe "#redhat_linux?" do
    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      file = '/etc/redhat-release'

      context "and the #{file} file exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(true)
        end

        it { expect(subject.redhat_linux?).to be(true) }
      end

      context "but the /etc/redhat-release file does not exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(false)
        end

        it { expect(subject.redhat_linux?).to be(false) }
      end
    end

    context "when RUBY_PLATFORM does not contain 'linux'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.redhat_linux?).to be(false) }
    end
  end

  describe "#fedora_linux?" do
    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      file = '/etc/fedora-release'

      context "and the #{file} file exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(true)
        end

        it { expect(subject.fedora_linux?).to be(true) }
      end

      context "but the #{file} file does not exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(false)
        end

        it { expect(subject.fedora_linux?).to be(false) }
      end
    end

    context "when RUBY_PLATFORM does not contain 'linux'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.fedora_linux?).to be(false) }
    end
  end

  describe "#debian_linux?" do
    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      file = '/etc/debian_version'

      context "and the #{file} file exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(true)
        end

        it { expect(subject.debian_linux?).to be(true) }
      end

      context "but the #{file} file does not exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(false)
        end

        it { expect(subject.debian_linux?).to be(false) }
      end
    end

    context "when RUBY_PLATFORM does not contain 'linux'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.debian_linux?).to be(false) }
    end
  end

  describe "#suse_linux?" do
    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      file = '/etc/SuSE-release'

      context "and the #{file} file exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(true)
        end

        it { expect(subject.suse_linux?).to be(true) }
      end

      context "but the #{file} file does not exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(false)
        end

        it { expect(subject.suse_linux?).to be(false) }
      end
    end

    context "when RUBY_PLATFORM does not contain 'linux'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.suse_linux?).to be(false) }
    end
  end

  describe "#arch_linux?" do
    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      file = '/etc/arch-release'

      context "and the #{file} file exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(true)
        end

        it { expect(subject.arch_linux?).to be(true) }
      end

      context "but the #{file} file does not exists" do
        before do
          expect(File).to receive(:file?).with(file).and_return(false)
        end

        it { expect(subject.arch_linux?).to be(false) }
      end
    end

    context "when RUBY_PLATFORM does not contain 'linux'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.arch_linux?).to be(false) }
    end
  end

  describe "#macos?" do
    context "when RUBY_PLATFORM contains 'darwin'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.macos?).to be(true) }
    end

    context "when RUBY_PLATFORM does not contain 'darwin'" do
      before { stub_const('RUBY_PLATFORM','mswin') }

      it { expect(subject.macos?).to be(false) }
    end
  end

  describe "#freebsd?" do
    context "when RUBY_PLATFORM contains 'freebsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-freebsd') }

      it { expect(subject.freebsd?).to be(true) }
    end

    context "when RUBY_PLATFORM does not contain 'freebsd'" do
      before { stub_const('RUBY_PLATFORM','mswin') }

      it { expect(subject.freebsd?).to be(false) }
    end
  end

  describe "#unix?" do
    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      it { expect(subject.unix?).to be(true) }
    end

    context "when RUBY_PLATFORM contains 'darwin'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.unix?).to be(true) }
    end

    context "when RUBY_PLATFORM contains 'freebsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-freebsd') }

      it { expect(subject.freebsd?).to be(true) }
    end

    context "when RUBY_PLATFORM contains 'mswin'" do
      before { stub_const('RUBY_PLATFORM','mswin') }

      it { expect(subject.unix?).to be(false) }
    end
  end

  describe "#windows?" do
    it "must call Gem.win_platform?" do
      expect(Gem).to receive(:win_platform?)

      subject.windows?
    end
  end

  describe "#os" do
    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      it { expect(subject.os).to eq(:linux) }
    end

    context "when RUBY_PLATFORM contains 'darwin'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.os).to eq(:macos) }
    end

    context "when RUBY_PLATFORM contains 'freebsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-freebsd') }

      it { expect(subject.os).to eq(:freebsd) }
    end

    context "when Gem.win_platform? returns true" do
      before { stub_const('RUBY_PLATFORM','mswin') }

      before do
        expect(Gem).to receive(:win_platform?).and_return(true)
      end

      it { expect(subject.os).to eq(:windows) }
    end

    context "when the OS cannot be identified" do
      before { stub_const('RUBY_PLATFORM','foo') }

      it { expect(subject.os).to be(nil) }
    end
  end
end
