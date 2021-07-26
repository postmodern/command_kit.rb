require 'spec_helper'
require 'command_kit/os/linux'

describe CommandKit::OS::Linux do
  module TestOSLinux
    class TestCommand
      include CommandKit::OS::Linux
    end
  end

  let(:command_class) { TestOSLinux::TestCommand }

  describe ".linux_distro" do
    subject { command_class }

    context "and the /etc/fedora-release file exists" do
      before do
        expect(File).to receive(:file?).with("/etc/fedora-release").and_return(true)
      end

      it { expect(subject.linux_distro).to be(:fedora) }
    end

    context "and the /etc/redhat-release file exists" do
      before do
        allow(File).to receive(:file?).with("/etc/fedora-release").and_return(false)
        expect(File).to receive(:file?).with("/etc/redhat-release").and_return(true)
      end

      it { expect(subject.linux_distro).to be(:redhat) }
    end

    context "and the /etc/debian_version file exists" do
      before do
        allow(File).to receive(:file?).with("/etc/fedora-release").and_return(false)
        allow(File).to receive(:file?).with("/etc/redhat-release").and_return(false)
        expect(File).to receive(:file?).with("/etc/debian_version").and_return(true)
      end

      it { expect(subject.linux_distro).to be(:debian) }
    end

    context "and the /etc/SuSE-release file exists" do
      before do
        allow(File).to receive(:file?).with("/etc/fedora-release").and_return(false)
        allow(File).to receive(:file?).with("/etc/redhat-release").and_return(false)
        allow(File).to receive(:file?).with("/etc/debian_version").and_return(false)
        expect(File).to receive(:file?).with("/etc/SuSE-release").and_return(true)
      end

      it { expect(subject.linux_distro).to be(:suse) }
    end

    context "and the /etc/arch-release file exists" do
      before do
        allow(File).to receive(:file?).with("/etc/fedora-release").and_return(false)
        allow(File).to receive(:file?).with("/etc/redhat-release").and_return(false)
        allow(File).to receive(:file?).with("/etc/debian_version").and_return(false)
        allow(File).to receive(:file?).with("/etc/SuSE-release").and_return(false)
        expect(File).to receive(:file?).with("/etc/arch-release").and_return(true)
      end

      it { expect(subject.linux_distro).to be(:arch) }
    end
  end

  subject { command_class.new }

  describe "#initialize" do
    it "must default #linux_distro to self.class.linux_distro" do
      expect(subject.linux_distro).to eq(command_class.linux_distro)
    end

    context "when the linux_distro: keyword is given" do
      let(:linux_distro) { :suse }

      subject { command_class.new(linux_distro: linux_distro) }

      it "must set #linux_distro" do
        expect(subject.linux_distro).to eq(linux_distro)
      end
    end
  end

  describe "#redhat_linux?" do
    context "when #linux_distro is :redhat" do
      subject { command_class.new(linux_distro: :redhat) }

      it { expect(subject.redhat_linux?).to be(true) }
    end

    context "when #linux_distro is not :redhat" do
      subject { command_class.new(linux_distro: :debian) }

      it { expect(subject.redhat_linux?).to be(false) }
    end
  end

  describe "#fedora_linux?" do
    context "when #linux_distro is :fedora" do
      subject { command_class.new(linux_distro: :fedora) }

      it { expect(subject.fedora_linux?).to be(true) }
    end

    context "when #linux_distro is not :fedora" do
      subject { command_class.new(linux_distro: :debian) }

      it { expect(subject.fedora_linux?).to be(false) }
    end
  end

  describe "#debian_linux?" do
    context "when #linux_distro is :debian" do
      subject { command_class.new(linux_distro: :debian) }

      it { expect(subject.debian_linux?).to be(true) }
    end

    context "when #linux_distro is not :fedora" do
      subject { command_class.new(linux_distro: :redhat) }

      it { expect(subject.debian_linux?).to be(false) }
    end
  end

  describe "#suse_linux?" do
    context "when #linux_distro is :suse" do
      subject { command_class.new(linux_distro: :suse) }

      it { expect(subject.suse_linux?).to be(true) }
    end

    context "when #linux_distro is not :suse" do
      subject { command_class.new(linux_distro: :debian) }

      it { expect(subject.suse_linux?).to be(false) }
    end
  end

  describe "#arch_linux?" do
    context "when #linux_distro is :arch" do
      subject { command_class.new(linux_distro: :arch) }

      it { expect(subject.arch_linux?).to be(true) }
    end

    context "when #linux_distro is not :arch" do
      subject { command_class.new(linux_distro: :debian) }

      it { expect(subject.arch_linux?).to be(false) }
    end
  end
end
