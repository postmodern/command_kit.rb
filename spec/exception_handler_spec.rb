require 'spec_helper'
require 'command_kit/exception_handler'

describe CommandKit::ExceptionHandler do
  module TestExceptionHandler
    class TestIncludedCmd

      include CommandKit::Main
      include CommandKit::ExceptionHandler

    end
  end

  let(:command_class) { TestExceptionHandler::TestIncludedCmd }
  subject { command_class.new }

  describe ".included" do
    it "must include CommandKit::Printing" do
      expect(command_class).to be_include(CommandKit::Printing)
    end
  end

  describe "#main" do
    context "when the #main method rescues an Interrupt" do
      module TestExceptionHandler
        class RaisesInterruptCmd

          include CommandKit::Main
          include CommandKit::ExceptionHandler

          def run
            raise(Interrupt.new)
          end

        end
      end

      let(:command_class) { TestExceptionHandler::RaisesInterruptCmd }
      subject { command_class.new }

      it "must re-raise the Interrupt exception" do
        expect { subject.main }.to raise_error(Interrupt)
      end
    end

    context "when the #main method raises an Errno::EPIPE" do
      module TestExceptionHandler
        class RaisesErrnoEPIPECmd

          include CommandKit::Main
          include CommandKit::ExceptionHandler

          def run
            raise(Errno::EPIPE.new)
          end

        end
      end

      let(:command_class) { TestExceptionHandler::RaisesErrnoEPIPECmd }
      subject { command_class.new }

      it "must re-raise the Errno::EPIPE exception" do
        expect { subject.main }.to raise_error(Errno::EPIPE)
      end
    end

    context "when the #main method raises another Exception" do
      module TestExceptionHandler
        class RaisesExceptionCmd

          include CommandKit::Main
          include CommandKit::ExceptionHandler

          def run
            raise("error")
          end

        end
      end

      let(:command_class) { TestExceptionHandler::RaisesExceptionCmd }
      subject { command_class.new }

      it "must rescue the exception and call #on_exception" do
        expect(subject).to receive(:on_exception).with(RuntimeError)

        subject.main
      end
    end
  end

  describe "#on_exception" do
    let(:error) { RuntimeError.new('error') }

    it "must call #print_exception and exit with 1" do
      expect(subject).to receive(:print_exception).with(error)
      expect(subject).to receive(:exit).with(1)

      subject.on_exception(error)
    end
  end
end
