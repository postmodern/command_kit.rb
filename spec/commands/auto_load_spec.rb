require 'spec_helper'
require 'command_kit/commands/auto_load'

describe CommandKit::Commands::AutoLoad do
  let(:fixtures_dir) { File.expand_path('../fixtures',__FILE__) }

  let(:dir)       { File.join(fixtures_dir,'test_auto_load','cli','commands') }
  let(:namespace) { 'TestAutoLoad::CLI::Commands' }

  subject { described_class.new(dir: dir, namespace: namespace) }

  describe "#initialize" do
    it "must set #dir" do
      expect(subject.dir).to eq(dir)
    end

    it "must set #namespace" do
      expect(subject.namespace).to eq(namespace)
    end

    it "must populate #commands based on the files within #dir" do
      expect(subject.commands['test1']).to be_kind_of(described_class::Subcommand)
      expect(subject.commands['test1'].constant).to eq("#{namespace}::Test1")
      expect(subject.commands['test1'].path).to eq(File.join(dir,'test1.rb'))

      expect(subject.commands['test2']).to be_kind_of(described_class::Subcommand)
      expect(subject.commands['test2'].constant).to eq("#{namespace}::Test2")
      expect(subject.commands['test2'].path).to eq(File.join(dir,'test2.rb'))
    end

    context "when given a block" do
      subject do
        described_class.new(dir: dir, namespace: namespace) do |autoload|
          autoload.command 'test-1', 'Test1', 'test1.rb'
          autoload.command 'test-2', 'Test2', 'test2.rb'
        end
      end

      it "must not populate #commands based on the files within #dir" do
        expect(subject.commands['test1']).to be(nil)
        expect(subject.commands['test2']).to be(nil)
      end

      it "must allow explicitly initializing #commands via #command" do
        expect(subject.commands['test-1']).to be_kind_of(described_class::Subcommand)
        expect(subject.commands['test-1'].constant).to eq("#{namespace}::Test1")
        expect(subject.commands['test-1'].path).to eq(File.join(dir,'test1.rb'))

        expect(subject.commands['test-2']).to be_kind_of(described_class::Subcommand)
        expect(subject.commands['test-2'].constant).to eq("#{namespace}::Test2")
        expect(subject.commands['test-2'].path).to eq(File.join(dir,'test2.rb'))
      end
    end
  end

  module TestAutoLoad
    class TestCommand
      include CommandKit::Commands
      include CommandKit::Commands::AutoLoad.new(
        dir:       File.expand_path('../fixtures/test_auto_load/cli/commands',__FILE__),
        namespace: "#{self}::Commands"
      )
    end

    class TestCommandWithBlock
      include CommandKit::Commands
      include(CommandKit::Commands::AutoLoad.new(
        dir:       File.expand_path('../fixtures/test_auto_load/cli/commands',__FILE__),
        namespace: "#{self}::Commands"
      ) { |autoload|
        autoload.command 'test-1', 'Test1', 'test1.rb', aliases: %w[test_1]
        autoload.command 'test-2', 'Test2', 'test2.rb', aliases: %w[test_2]
      })
    end
  end

  let(:command_class)   { TestAutoLoad::TestCommand }
  let(:autoload_module) { command_class.included_modules.first }

  describe "#included" do
    subject { command_class }

    it "must also include CommandKit::Commands" do
      expect(subject).to include(CommandKit::Commands)
    end

    it "must merge the module's #commands into the class'es #commands" do
      expect(command_class.commands).to include(autoload_module.commands)
    end

    context "when CommandKit::Commands::AutoLoad has an explicit mapping" do
      let(:command_class) { TestAutoLoad::TestCommandWithBlock }

      it "must merge the module's #commands into the class'es #commands" do
        expect(command_class.commands).to include(autoload_module.commands)
      end

      it "must also merge the any aliases into the class'es #command_aliases" do
        expected_command_aliases = {}

        autoload_module.commands.each do |name,subcommand|
          subcommand.aliases.each do |alias_name|
            expected_command_aliases[alias_name] = name
          end
        end

        expect(command_class.command_aliases).to include(expected_command_aliases)
      end
    end
  end

  describe "#join" do
    let(:path) { 'foo/bar' }

    it "must join the path with #dir" do
      expect(subject.join(path)).to eq(File.join(dir,path))
    end
  end

  describe "#files" do
    it "must list the files within the auto-load directory" do
      expect(subject.files).to eq(Dir["#{dir}/*.rb"])
    end
  end

  describe "#command" do
    let(:command_name) { 'test' }
    let(:constant)     { 'Test' }
    let(:file)         { 'test.rb' }

    before do
      subject.command command_name, constant, file
    end

    it "must add a Subcommand to #commands with the given command name" do
      expect(subject.commands[command_name]).to be_kind_of(described_class::Subcommand)
    end

    it "must join the given file: value with #dir" do
      expect(subject.commands[command_name].path).to eq(File.join(dir,file))
    end

    it "must combine the given constant: value with #namespace" do
      expect(subject.commands[command_name].constant).to eq("#{namespace}::#{constant}")
    end

    context "when given a summary: value" do
      let(:summary) { 'Test is a test' }

      before do
        subject.command command_name, constant, file, summary: summary
      end

      it "must set the subcommand's #summary" do
        expect(subject.commands[command_name].summary).to eq(summary)
      end
    end
  end
end
