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
end
