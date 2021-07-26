require 'spec_helper'
require 'command_kit/os/linux'

describe CommandKit::OS::Linux do
  class TestOSLinux
    include CommandKit::OS::Linux
  end

  subject { TestOSLinux.new }

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
end
