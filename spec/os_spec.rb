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

  describe "#openbsd?" do
    context "when RUBY_PLATFORM contains 'openbsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-openbsd') }

      it { expect(subject.openbsd?).to be(true) }
    end

    context "when RUBY_PLATFORM does not contain 'openbsd'" do
      before { stub_const('RUBY_PLATFORM','mswin') }

      it { expect(subject.openbsd?).to be(false) }
    end
  end

  describe "#netbsd?" do
    context "when RUBY_PLATFORM contains 'netbsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-netbsd') }

      it { expect(subject.netbsd?).to be(true) }
    end

    context "when RUBY_PLATFORM does not contain 'netbsd'" do
      before { stub_const('RUBY_PLATFORM','mswin') }

      it { expect(subject.netbsd?).to be(false) }
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

      it { expect(subject.unix?).to be(true) }
    end

    context "when RUBY_PLATFORM contains 'opensbd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-openbsd') }

      it { expect(subject.unix?).to be(true) }
    end

    context "when RUBY_PLATFORM contains 'netsbd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-netbsd') }

      it { expect(subject.unix?).to be(true) }
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

    context "when RUBY_PLATFORM contains 'openbsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-openbsd') }

      it { expect(subject.os).to eq(:openbsd) }
    end

    context "when RUBY_PLATFORM contains 'netbsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-netbsd') }

      it { expect(subject.os).to eq(:netbsd) }
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
