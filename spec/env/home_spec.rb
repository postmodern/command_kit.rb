require 'spec_helper'
require 'command_kit/env/home'

describe CommandKit::Env::Home do
  module TestEnvHome
    class TestCommand
      include CommandKit::Env::Home
    end
  end

  let(:command_class) { TestEnvHome::TestCommand }

  describe ".included" do
    it "must include CommandKit::Env" do
      expect(command_class).to be_include(CommandKit::Env)
    end
  end

  describe ".home_dir" do
    subject { command_class }

    it "must return Gem.user_home" do
      expect(subject.home_dir).to eq(Gem.user_home)
    end
  end

  describe "#home_dir" do
    context "when env['HOME'] is set" do
      let(:home_dir) { '/path/to/home_dir' }

      subject { command_class.new(env: {'HOME' => home_dir}) }

      it "must return the env['HOME'] value" do
        expect(subject.home_dir).to eq(home_dir)
      end
    end

    context "when env['HOME'] is not set" do
      subject { command_class.new(env: {}) }

      it "must return .home_dir" do
        expect(subject.home_dir).to eq(subject.class.home_dir)
      end
    end
  end
end
