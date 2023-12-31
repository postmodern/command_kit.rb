require 'spec_helper'
require 'command_kit/env/prefix'

describe CommandKit::Env::Prefix do
  module TestEnvPrefix
    class TestCommand
      include CommandKit::Env::Prefix
    end
  end

  let(:command_class) { TestEnvPrefix::TestCommand }

  let(:prefix) { '/foo' }

  subject do
    command_class.new(env: {'PREFIX' => prefix})
  end

  describe "#root" do
    context "when env['PREFIX'] is set" do
      it "must set #root to the env['PREFIX']" do
        expect(subject.root).to eq(prefix)
      end
    end

    context "when env['PREFIX'] is not set" do
      subject { command_class.new }

      it "must set #root to '/'" do
        expect(subject.root).to eq('/')
      end
    end
  end
end
