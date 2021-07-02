require 'spec_helper'
require 'command_kit/commands/auto_require'

describe CommandKit::Commands::AutoRequire do
  let(:fixtures_dir) { File.expand_path('../fixtures',__FILE__) }
  let(:lib_dir)      { File.join(fixtures_dir,'test_auto_require','lib') }
  let(:dir)          { File.join('test_auto_require','cli','commands') }
  let(:namespace) { 'TestAutoRequire::CLI::Commands' }

  before { $LOAD_PATH.unshift(lib_dir) }
  after  { $LOAD_PATH.delete(lib_dir)  }

  describe "#initialize" do
    subject { described_class.new(dir: dir, namespace: namespace) }

    it "must set #dir" do
      expect(subject.dir).to eq(dir)
    end

    it "must set #namespace" do
      expect(subject.namespace).to eq(namespace)
    end
  end

  module TestAutoRequire
    class CLI
      include CommandKit::Commands
      include CommandKit::Commands::AutoRequire.new(
        dir:       'test_auto_require/cli/commands',
        namespace: "#{self}::Commands"
      )
    end
  end

  let(:command_class)       { TestAutoRequire::CLI                 }
  let(:auto_require_module) { command_class.included_modules.first }

  subject { described_class.new(dir: dir, namespace: namespace) }

  describe "#join" do
    let(:path) { 'foo/bar' }

    it "must join the path with #dir" do
      expect(subject.join(path)).to eq(File.join(dir,path))
    end
  end

  let(:file_name) { 'test1' }

  describe "#require" do
    let(:path) { File.join(lib_dir,dir,"#{file_name}.rb") }

    it "must require #path" do
      expect($LOADED_FEATURES).to_not include(path)

      subject.require(file_name)

      expect($LOADED_FEATURES).to include(path)
    end

    context "when #path does not exist" do
      let(:file_name) { 'does_not_exist' }

      it do
        expect { subject.require(file_name) }.to raise_error(LoadError)
      end
    end
  end

  describe "#const_get" do
    before { subject.require(file_name) }

    let(:constant) { 'Test1' }

    it "must resolve the given constant within the namespace" do
      expect(subject.const_get(constant)).to eq(TestAutoRequire::CLI::Commands::Test1)
    end

    context "when the constant shadows a global constant" do
      let(:constant) { 'Object' }

      it do
        expect { subject.const_get(constant) }.to raise_error(NameError)
      end
    end

    context "when #constant cannot be found" do
      let(:constant) { 'DoesNotExist' }

      it do
        expect { subject.const_get(constant) }.to raise_error(NameError)
      end
    end
  end

  describe "#command" do
    let(:command_name) { 'test1' }

    it "must require the command's file and return the command class" do
      expect(subject.command(command_name)).to eq(TestAutoRequire::CLI::Commands::Test1)
    end

    context "when command's file cannot be found" do
      let(:command_name) { 'does_not_exist' }

      it do
        expect(subject.command(command_name)).to be(nil)
      end
    end
  end

  describe "#included" do
    subject { command_class }

    it "must also include CommandKit::Commands" do
      expect(subject).to include(CommandKit::Commands)
    end

    describe ".commands" do
      it "must set the class'es .commands.default_proc" do
        expect(command_class.commands.default_proc).to_not be(nil)
        expect(command_class.commands.default_proc).to be_kind_of(Proc)
      end

      let(:command_name) { 'test1' }

      it "the .commands.default_proc must auto-require commands and return a Subcommand" do
        expect(command_class.commands[command_name]).to_not be(nil)
        expect(command_class.commands[command_name]).to be_kind_of(CommandKit::Commands::Subcommand)
        expect(command_class.commands[command_name].command).to eq(TestAutoRequire::CLI::Commands::Test1)
      end

      context "when the given command_name cannot be auto-required" do
        let(:command_name) { 'does_not_exist' }

        it do
          expect(command_class.commands[command_name]).to be(nil)
        end
      end
    end
  end
end
