require 'spec_helper'
require 'command_kit/env/home'

describe Env::Home do
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

  describe ".home" do
    subject { command_class }

    it "must return Gem.user_home" do
      expect(subject.home).to eq(Gem.user_home)
    end
  end

  describe "#home" do
    context "when env['HOME'] is set" do
      let(:home) { '/path/to/home' }

      subject { command_class.new(env: {'HOME' => home}) }

      it "must return the env['HOME'] value" do
        expect(subject.home).to eq(home)
      end
    end

    context "when env['HOME'] is not set" do
      subject { command_class.new(env: {}) }

      it "must return .home" do
        expect(subject.home).to eq(subject.class.home)
      end
    end
  end
end
