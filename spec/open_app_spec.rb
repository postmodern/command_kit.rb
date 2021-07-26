require 'spec_helper'
require 'command_kit/open_app'

describe CommandKit::OpenApp do
  module TestOpenApp
    class TestCommand
      include CommandKit::OpenApp
    end
  end

  let(:command_class) { TestOpenApp::TestCommand }

  subject { command_class.new }

  describe "#initialize" do
    context "when the OS is macOS" do
      subject { command_class.new(os: :macos) }

      it "must set @open_command to \"open\"" do
        expect(subject.instance_variable_get("@open_command")).to eq("open")
      end
    end

    context "when the OS is Linux" do
      subject { command_class.new(os: :linux) }

      it "must set @open_command to \"xdg-open\"" do
        expect(subject.instance_variable_get("@open_command")).to eq("xdg-open")
      end
    end

    context "when the OS is FreeBSD" do
      subject { command_class.new(os: :freebsd) }

      it "must set @open_command to \"xdg-open\"" do
        expect(subject.instance_variable_get("@open_command")).to eq("xdg-open")
      end
    end

    context "when the OS is OpenBSD" do
      subject { command_class.new(os: :openbsd) }

      it "must set @open_command to \"xdg-open\"" do
        expect(subject.instance_variable_get("@open_command")).to eq("xdg-open")
      end
    end

    context "when the OS is NetBSD" do
      subject { command_class.new(os: :openbsd) }

      it "must set @open_command to \"xdg-open\"" do
        expect(subject.instance_variable_get("@open_command")).to eq("xdg-open")
      end
    end

    context "when the OS is Windows" do
      subject { command_class.new(os: :windows) }

      it "must set @open_command to \"start\"" do
        expect(subject.instance_variable_get("@open_command")).to eq("start")
      end
    end
  end

  describe "#open_app_for" do
    context "when @open_command is set" do
      let(:file_or_uri) { "foo" }
      let(:status) { true }

      it "must execute the @open_command with the given URI or file" do
        expect(subject).to receive(:system).with(subject.instance_variable_get("@open_command"),file_or_uri).and_return(status)

        expect(subject.open_app_for(file_or_uri)).to be(status)
      end
    end

    context "when @open_command is not set" do
      before do
        subject.instance_variable_set("@open_command",nil)
      end

      it { expect(subject.open_app_for("foo")).to be(nil) }
    end
  end
end
