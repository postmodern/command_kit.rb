require 'spec_helper'
require 'command_kit/env'

describe CommandKit::Env do
  module TestEnv
    class TestCommand
      include CommandKit::Env
    end
  end

  let(:command_class) { TestEnv::TestCommand }

  describe "#initialize" do
    module TestEnv
      class TestCommandWithInitialize
        include CommandKit::Env

        attr_reader :var

        def initialize
          @var = 'foo'
        end
      end

      class TestCommandWithInitializeAndKeywordArgs
        include CommandKit::Env

        attr_reader :var

        def initialize(var: "foo")
          @var = var
        end
      end
    end

    context "when given no arguments" do
      subject { command_class.new() }

      it "must initialize #env to ENV" do
        expect(subject.env).to be(ENV)
      end

      context "and the including class defines it's own #initialize method" do
        let(:command_class) { TestEnv::TestCommandWithInitialize }

        it "must initialize #env to ENV" do
          expect(subject.env).to be(ENV)
        end

        it "must also call the class'es #initialize method" do
          expect(subject.var).to eq('foo')
        end

        context "and it accepts keyword arguments" do
          let(:command_class) { TestEnv::TestCommandWithInitializeAndKeywordArgs }
          let(:var) { 'custom value' }

          subject { command_class.new(var: var) }

          it "must initialize #env to ENV" do
            expect(subject.env).to be(ENV)
          end

          it "must also call the class'es #initialize method with any additional keyword arguments" do
            expect(subject.var).to eq(var)
          end
        end
      end
    end

    context "when given a custom env: value" do
      let(:custom_env) { {'FOO' => 'bar'} }

      subject { command_class.new(env: custom_env) }

      it "must initialize #env to the env: value" do
        expect(subject.env).to eq(custom_env)
      end

      context "and the including class defines it's own #initialize method" do
        let(:command_class) { TestEnv::TestCommandWithInitialize }

        it "must initialize #env to the env: value" do
          expect(subject.env).to eq(custom_env)
        end

        it "must also call the class'es #initialize method" do
          expect(subject.var).to eq('foo')
        end

        context "and it accepts keyword arguments" do
          let(:command_class) { TestEnv::TestCommandWithInitializeAndKeywordArgs }
          let(:var) { 'custom value' }

          subject { command_class.new(env: custom_env, var: var) }

          it "must initialize #env to the env: value" do
            expect(subject.env).to eq(custom_env)
          end

          it "must also call the class'es #initialize method with any additional keyword arguments" do
            expect(subject.var).to eq(var)
          end
        end
      end
    end
  end

  describe "#env" do
    let(:command_class) { TestEnv::TestCommand }
    let(:env) { {"FOO" => "bar" } }

    subject { command_class.new(env: env) }

    it "must return the initialized env: value" do
      expect(subject.env).to eq(env)
    end
  end
end
