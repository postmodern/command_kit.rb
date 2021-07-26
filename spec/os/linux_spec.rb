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

  describe "#linux_distro" do
    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      context "when both the /etc/redhat-release and /etc/fedora-release files exist" do
        before do
          allow(File).to receive(:file?).with('/etc/redhat-release').and_return(true)
          allow(File).to receive(:file?).with('/etc/fedora-release').and_return(true)
        end

        it { expect(subject.linux_distro).to eq(:fedora) }
      end

      context "when the /etc/redhat-release file exists" do
        before do
          allow(File).to receive(:file?).with('/etc/redhat-release').and_return(true)
          allow(File).to receive(:file?).with('/etc/fedora-release').and_return(false)
        end

        it { expect(subject.linux_distro).to eq(:redhat) }
      end

      context "when the /etc/debian_version file exists" do
        before do
          allow(File).to receive(:file?).with('/etc/redhat-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/fedora-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/debian_version').and_return(true)
        end

        it { expect(subject.linux_distro).to eq(:debian) }
      end

      context "when the /etc/SuSE-release file exists" do
        before do
          allow(File).to receive(:file?).with('/etc/redhat-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/fedora-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/debian_version').and_return(false)
          allow(File).to receive(:file?).with('/etc/SuSE-release').and_return(true)
        end

        it { expect(subject.linux_distro).to eq(:suse) }
      end

      context "when the /etc/arch-release file exists" do
        before do
          allow(File).to receive(:file?).with('/etc/redhat-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/fedora-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/debian_version').and_return(false)
          allow(File).to receive(:file?).with('/etc/SuSE-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/arch-release').and_return(true)
        end

        it { expect(subject.linux_distro).to eq(:arch) }
      end

      context "when none of the files exist" do
        before do
          allow(File).to receive(:file?).with('/etc/redhat-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/fedora-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/debian_version').and_return(false)
          allow(File).to receive(:file?).with('/etc/SuSE-release').and_return(false)
          allow(File).to receive(:file?).with('/etc/arch-release').and_return(false)
        end

        it { expect(subject.linux_distro).to be(nil) }
      end
    end

    context "when RUBY_PLATFORM does not contain 'linux'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.linux_distro).to be(nil) }
    end
  end
end
