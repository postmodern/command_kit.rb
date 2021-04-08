require 'spec_helper'
require 'command_kit/commands/auto_load/subcommand'

describe Commands::AutoLoad::Subcommand do
  let(:fixtures_dir) { File.expand_path('../../fixtures',__FILE__) }

  let(:file) { 'test1.rb' }
  let(:path) { File.join(fixtures_dir,'test_auto_load/cli/commands',file) }

  let(:class_name) { 'Test1' }
  let(:constant) { "TestAutoLoad::CLI::Commands::#{class_name}" }

  subject { described_class.new(constant,path) }

  describe "#initialize" do
    it "must set #constant" do
      expect(subject.constant).to eq(constant)
    end

    it "must set #path" do
      expect(subject.path).to eq(path)
    end

    context "when an explicit summary: option is given" do
      let(:summary) { 'This is a test' }

      subject { described_class.new(constant,path, summary: summary) }

      it "must set #summary" do
        expect(subject.summary).to eq(summary)
      end
    end
  end

  describe "#require!" do
    it "must require #path" do
      expect($LOADED_FEATURES).to_not include(path)

      subject.require!

      expect($LOADED_FEATURES).to include(path)
    end

    context "when #path does not exist" do
      let(:path) { '/does/not/exist' }

      it do
        expect { subject.require! }.to raise_error(LoadError)
      end
    end
  end

  describe "#const_get" do
    before { subject.require! }

    it "must resolve #constant" do
      expect(subject.const_get).to eq(TestAutoLoad::CLI::Commands::Test1)
    end

    context "when the constant shadows a global constant" do
      let(:constant) { 'TestAutoLoad::CLI::Commands::Object' }

      it do
        expect { subject.const_get }.to raise_error(NameError)
      end
    end

    context "when #constant cannot be found" do
      let(:constant) { 'Does::Not::Exist' }

      it do
        expect { subject.const_get }.to raise_error(NameError)
      end
    end
  end

  describe "#command" do
    it "return the command class" do
      expect(subject.command).to eq(TestAutoLoad::CLI::Commands::Test1)
    end
  end
end
