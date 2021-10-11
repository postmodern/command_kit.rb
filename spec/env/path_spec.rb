require 'spec_helper'
require 'command_kit/env/path'

describe CommandKit::Env::Path do
  module TestEnvPath
    class TestCommand

      include CommandKit::Env::Path

    end
  end

  let(:command_class) { TestEnvPath::TestCommand }
  subject { command_class.new }

  describe ".included" do
    it "must include CommandKit::Env" do
      expect(command_class).to be_include(CommandKit::Env)
    end
  end

  describe "#initialize" do
    it "must split ENV['PATH'] into an Array of directories" do
      expect(subject.path_dirs).to eq(ENV['PATH'].split(File::PATH_SEPARATOR))
    end

    context "when given a custom 'PATH variable" do
      let(:path_dirs) { %w[/bin /usr/bin] }
      let(:path)      { path_dirs.join(File::PATH_SEPARATOR) }

      subject { command_class.new(env: {'PATH' => path}) }

      it "must split env['PATH'] into an Array of directories" do
        expect(subject.path_dirs).to eq(path_dirs)
      end
    end

    context "when given an empty 'PATH' env variable" do
      subject { command_class.new(env: {'PATH' => ''}) }

      it "must set #path_dirs to []" do
        expect(subject.path_dirs).to eq([])
      end
    end
  end

  describe "#find_command" do
    context "when given a valid command name" do
      it "must search #path_dirs for the command" do
        command = subject.find_command('ruby')

        expect(subject.path_dirs).to include(File.dirname(command))
      end

      it "must return the path to the command" do
        command = subject.find_command('ruby')

        expect(command).to_not be(nil)
        expect(File.file?(command)).to be(true)
        expect(File.executable?(command)).to be(true)
      end
    end

    context "when given an unknown command name" do
      it "must return nil" do
        expect(subject.find_command('does_not_exist')).to be(nil)
      end
    end
  end

  describe "#command_installed?" do
    context "when given a valid command name" do
      it do
        expect(subject.command_installed?('ruby')).to be(true)
      end
    end

    context "when given an unknown command name" do
      it "must return nil" do
        expect(subject.command_installed?('does_not_exist')).to be(false)
      end
    end
  end
end
