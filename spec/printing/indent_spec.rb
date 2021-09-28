require 'spec_helper'
require 'command_kit/printing/indent'

describe CommandKit::Printing::Indent do
  module TestIndent
    class TestCommand
      include CommandKit::Printing::Indent
    end
  end

  let(:command_class) { TestIndent::TestCommand }
  subject { command_class.new }

  describe "#initialize" do
    it "must initialize #indent to 0" do
      expect(subject.indent).to eq(0)
    end

    context "when the class has a superclass" do
      module TestIndent
        class TestSuperCommand

          attr_reader :var

          def initialize(var: 'default')
            @var = var
          end

        end

        class TestSubCommand < TestSuperCommand

          include CommandKit::Printing::Indent

        end
      end

      let(:command_class) { TestIndent::TestSubCommand }

      it "must initialize @indent to 0" do
        expect(subject.indent).to eq(0)
      end

      it "must call super()" do
        expect(subject.var).to eq('default')
      end

      context "and additional keyword arguments are given" do
        let(:var) { 'foo' }

        subject { command_class.new(var: var) }

        it "must call super() with the additional keyword arguments" do
          expect(subject.var).to eq(var)
        end
      end
    end
  end

  describe "#indent" do
    context "when no block is given" do
      it "must return the indentation level" do
        expect(subject.indent).to eq(0)
      end
    end

    context "when a block is given" do
      it do
        expect { |b| subject.indent(&b) }.to yield_control
      end

      it "must increase the indent level by 2 then yield" do
        expect(subject.indent).to eq(0)
        
        subject.indent do
          expect(subject.indent).to eq(2)
        end
      end

      it "must restore the indententation level to it's original value" do
        subject.indent do
          expect(subject.indent).to eq(2)
        end

        expect(subject.indent).to eq(0)
      end

      context "when an exception occurrs within the given block" do
        it "must not rescue the exception" do
          expect {
            subject.indent do
              raise("error")
            end
          }.to raise_error(RuntimeError,"error")
        end

        it "must restore the indententation level to it's original value" do
          begin
            subject.indent do
              expect(subject.indent).to eq(2)
              raise("error")
            end
          rescue
          end

          expect(subject.indent).to eq(0)
        end
      end
    end
  end

  describe "#puts" do
    let(:nl)   { $/ }
    let(:text) { 'hello world' }

    context "when the indententation level is 0" do
      it "must not add leading indentation" do
        expect { subject.puts(text) }.to output("#{text}#{nl}").to_stdout
      end
    end

    context "when the indententation level is > 0" do
      it "must add a number of spaces to the text" do
        expect {
          subject.indent do
            subject.puts(text)
          end
        }.to output("  #{text}#{nl}").to_stdout
      end
    end
  end
end
