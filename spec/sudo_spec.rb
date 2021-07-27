require 'spec_helper'
require 'command_kit/sudo'

describe CommandKit::Sudo do
  module TestSudo
    class TestCommand
      include CommandKit::Sudo
    end
  end

  let(:command_class) { TestSudo::TestCommand }
  subject { command_class.new }

  describe "#sudo" do
    let(:command) { "ls" }
    let(:arguments) { ["-la", "~root"] }
    let(:status) { double(:status) }

    context "on UNIX" do
      context "when the UID is 0" do
        before { allow(Process).to receive(:uid).and_return(0) }

        it "must execute the command without sudo" do
          expect(subject).to receive(:system).with(command,*arguments).and_return(status)

          expect(subject.sudo(command,*arguments)).to be(status)
        end
      end

      context "when the UID is not 0" do
        before { allow(Process).to receive(:uid).and_return(1000) }

        it "must execute the command with 'sudo ...'" do
          expect(subject).to receive(:system).with('sudo',command,*arguments).and_return(status)

          expect(subject.sudo(command,*arguments)).to be(status)
        end
      end
    end

    context "on Windows" do
      subject { command_class.new(os: :windows) }

      it "must execute the command with 'runas /user:administrator ...'" do
        expect(subject).to receive(:system).with('runas','/user:administrator',command,*arguments).and_return(status)

        expect(subject.sudo(command,*arguments)).to be(status)
      end
    end
  end
end
