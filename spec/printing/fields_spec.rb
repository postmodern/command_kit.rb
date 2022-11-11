require 'spec_helper'
require 'command_kit/printing/fields'

describe CommandKit::Printing::Fields do
  module TestPrintingFields
    class TestCmd

      include CommandKit::Printing::Fields

    end
  end

  let(:command_class) { TestPrintingFields::TestCmd }
  subject { command_class.new }
  
  let(:nl) { $/ }

  describe "#print_fields" do
    context "when given a Hash" do
      context "and all key values are the same length" do
        let(:name1)  { 'A'   }
        let(:value1) { 'foo' }
        let(:name2)  { 'B'   }
        let(:value2) { 'bar' }

        let(:hash) do
          {
            name1 => value1,
            name2 => value2
          }
        end

        it "must not left-justify the Hash keys" do
          expect {
            subject.print_fields(hash)
          }.to output("#{name1}: #{value1}#{nl}#{name2}: #{value2}#{nl}").to_stdout
        end
      end

      context "but key values have different lengths" do
        let(:name1)  { 'A'   }
        let(:value1) { 'foo' }
        let(:name2)  { 'Bar' }
        let(:value2) { 'bar' }

        let(:hash) do
          {
            name1 => value1,
            name2 => value2
          }
        end

        it "must left-justify the Hash keys" do
          expect {
            subject.print_fields(hash)
          }.to output("#{name1}:   #{value1}#{nl}#{name2}: #{value2}#{nl}").to_stdout
        end
      end

      context "but the key values are not Strings" do
        let(:name1)  { 1     }
        let(:value1) { 'foo' }
        let(:name2)  { 100   }
        let(:value2) { 'bar' }

        let(:hash) do
          {
            name1 => value1,
            name2 => value2
          }
        end

        it "must convert them to Strings before calculating justification" do
          expect {
            subject.print_fields(hash)
          }.to output("#{name1}:   #{value1}#{nl}#{name2}: #{value2}#{nl}").to_stdout
        end
      end
    end

    context "when given an Array of tuples" do
      context "and all first tuple values are the same length" do
        let(:name1)  { 'A'   }
        let(:value1) { 'foo' }
        let(:name2)  { 'B'   }
        let(:value2) { 'bar' }

        let(:array) do
          [
            [name1, value1],
            [name2, value2]
          ]
        end

        it "must not left-justify the tuples" do
          expect {
            subject.print_fields(array)
          }.to output("#{name1}: #{value1}#{nl}#{name2}: #{value2}#{nl}").to_stdout
        end
      end

      context "but first tuple values have different lengths" do
        let(:name1)  { 'A'   }
        let(:value1) { 'foo' }
        let(:name2)  { 'Bar' }
        let(:value2) { 'bar' }

        let(:array) do
          [
            [name1, value1],
            [name2, value2]
          ]
        end

        it "must left-justify the tuples" do
          expect {
            subject.print_fields(array)
          }.to output("#{name1}:   #{value1}#{nl}#{name2}: #{value2}#{nl}").to_stdout
        end
      end

      context "but the first tuple values are not Strings" do
        let(:name1)  { 1     }
        let(:value1) { 'foo' }
        let(:name2)  { 100   }
        let(:value2) { 'bar' }

        let(:array) do
          [
            [name1, value1],
            [name2, value2]
          ]
        end

        it "must convert them to Strings before calculating justification" do
          expect {
            subject.print_fields(array)
          }.to output("#{name1}:   #{value1}#{nl}#{name2}: #{value2}#{nl}").to_stdout
        end
      end
    end

    context "but the values contain multiple lines" do
      let(:name1)  { 'A'   }
      let(:value1) { 'foo' }
      let(:name2)  { 'Bar' }
      let(:line1)  { 'bar' }
      let(:line2)  { 'baz' }
      let(:value2) do
        [line1, line2].join($/)
      end

      let(:hash) do
        {
          name1 => value1,
          name2 => value2
        }
      end

      it "must print the header with the first line and then indent the other lines" do
        expect {
          subject.print_fields(hash)
        }.to output("#{name1}:   #{value1}#{nl}#{name2}: #{line1}#{nl}     #{line2}#{nl}").to_stdout
      end
    end
  end
end
