require 'spec_helper'
require 'command_kit/exit'

describe CommandKit::Exit do
  module TestExit
    class TestCommand
      include CommandKit::Exit
    end
  end

  let(:test_command) { TestExit::TestCommand }

  subject { test_command.new }

  describe "#exit" do
    it do
      expect { subject.exit }.to raise_error(SystemExit)
    end

    context "when given no arguments" do
      subject do
        begin
          super().exit
        rescue SystemExit => system_exit
          system_exit
        end
      end

      it { expect(subject.status).to be(0) }
    end

    context "when given a status code" do
      let(:status) { -1 }
      subject do
        begin
          super().exit(status)
        rescue SystemExit => system_exit
          system_exit
        end
      end

      it { expect(subject.status).to be(status) }
    end
  end
end
