require 'spec_helper'
require 'command_kit/os'

describe CommandKit::OS do
  module TestOS
    class TestCommand
      include CommandKit::OS
    end
  end

  let(:command_class) { TestOS::TestCommand }
  subject { command_class.new }

  describe ".os" do
    subject { command_class }

    context "when RUBY_PLATFORM contains 'linux'" do
      before { stub_const('RUBY_PLATFORM','x86_64-linux') }

      it { expect(subject.os).to be(:linux) }
    end

    context "when RUBY_PLATFORM contains 'darwin'" do
      before { stub_const('RUBY_PLATFORM','aarch64-darwin') }

      it { expect(subject.os).to be(:macos) }
    end

    context "when RUBY_PLATFORM contains 'freebsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-freebsd') }

      it { expect(subject.os).to be(:freebsd) }
    end

    context "when RUBY_PLATFORM contains 'openbsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-openbsd') }

      it { expect(subject.os).to be(:openbsd) }
    end

    context "when RUBY_PLATFORM contains 'netbsd'" do
      before { stub_const('RUBY_PLATFORM','x86_64-netbsd') }

      it { expect(subject.os).to be(:netbsd) }
    end

    context "when Gem.win_platform? returns true" do
      before do
        stub_const('RUBY_PLATFORM','x86_64-mswin')

        expect(Gem).to receive(:win_platform?).and_return(true)
      end

      it { expect(subject.os).to be(:windows) }
    end
  end

  describe "#initialize" do
    it "must default #os to self.class.os" do
      expect(subject.os).to eq(command_class.os)
    end

    context "when initialized with the os: keyword" do
      let(:os) { :netbsd }

      subject { command_class.new(os: os) }

      it "must set #os" do
        expect(subject.os).to eq(os)
      end
    end
  end

  describe "#linux?" do
    context "when #os is :linux" do
      subject { command_class.new(os: :linux) }

      it { expect(subject.linux?).to be(true) }
    end

    context "when #os is not :linux" do
      subject { command_class.new(os: :windows) }

      it { expect(subject.linux?).to be(false) }
    end
  end

  describe "#macos?" do
    context "when #os is :macos" do
      subject { command_class.new(os: :macos) }

      it { expect(subject.macos?).to be(true) }
    end

    context "when #os is not :macos" do
      subject { command_class.new(os: :windows) }

      it { expect(subject.macos?).to be(false) }
    end
  end

  describe "#freebsd?" do
    context "when #os is :freebsd" do
      subject { command_class.new(os: :freebsd) }

      it { expect(subject.freebsd?).to be(true) }
    end

    context "when #os is not :freebsd" do
      subject { command_class.new(os: :windows) }

      it { expect(subject.freebsd?).to be(false) }
    end
  end

  describe "#openbsd?" do
    context "when #os is :openbsd" do
      subject { command_class.new(os: :openbsd) }

      it { expect(subject.openbsd?).to be(true) }
    end

    context "when #os is not :openbsd" do
      subject { command_class.new(os: :windows) }

      it { expect(subject.openbsd?).to be(false) }
    end
  end

  describe "#netbsd?" do
    context "when #os is :netbsd" do
      subject { command_class.new(os: :netbsd) }

      it { expect(subject.netbsd?).to be(true) }
    end

    context "when #os is not :netbsd" do
      subject { command_class.new(os: :windows) }

      it { expect(subject.netbsd?).to be(false) }
    end
  end

  describe "#bsd?" do
    context "when #os is :freebsd" do
      subject { command_class.new(os: :freebsd) }

      it { expect(subject.bsd?).to be(true) }
    end

    context "when #os is :openbsd" do
      subject { command_class.new(os: :openbsd) }

      it { expect(subject.bsd?).to be(true) }
    end

    context "when #os is :netbsd" do
      subject { command_class.new(os: :netbsd) }

      it { expect(subject.bsd?).to be(true) }
    end

    context "when #os is :macos" do
      subject { command_class.new(os: :macos) }

      it { expect(subject.bsd?).to be(false) }
    end

    context "when #os is :linux" do
      subject { command_class.new(os: :linux) }

      it { expect(subject.bsd?).to be(false) }
    end

    context "when #os is :windows" do
      subject { command_class.new(os: :windows) }

      it { expect(subject.bsd?).to be(false) }
    end
  end

  describe "#unix?" do
    context "when #os is :freebsd" do
      subject { command_class.new(os: :freebsd) }

      it { expect(subject.unix?).to be(true) }
    end

    context "when #os is :openbsd" do
      subject { command_class.new(os: :openbsd) }

      it { expect(subject.unix?).to be(true) }
    end

    context "when #os is :netbsd" do
      subject { command_class.new(os: :netbsd) }

      it { expect(subject.unix?).to be(true) }
    end

    context "when #os is :macos" do
      subject { command_class.new(os: :macos) }

      it { expect(subject.unix?).to be(true) }
    end

    context "when #os is :linux" do
      subject { command_class.new(os: :linux) }

      it { expect(subject.unix?).to be(true) }
    end

    context "when #os is :windows" do
      subject { command_class.new(os: :windows) }

      it { expect(subject.unix?).to be(false) }
    end
  end

  describe "#windows?" do
    context "when #os is :windows" do
      subject { command_class.new(os: :windows) }

      it { expect(subject.windows?).to be(true) }
    end

    context "when #os is not :windows" do
      subject { command_class.new(os: :linux) }

      it { expect(subject.windows?).to be(false) }
    end
  end
end
