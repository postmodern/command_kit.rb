require 'spec_helper'
require 'command_kit/printing/tables/cell_builder'

describe CommandKit::Printing::Tables::CellBuilder do
  describe "#initialize" do
    it "must initialize #lines to an empty Array" do
      expect(subject.lines).to eq([])
    end

    it "must default #height to 0" do
      expect(subject.height).to eq(0)
    end

    it "must default #width to 0" do
      expect(subject.width).to eq(0)
    end

    context "when an initial value is given" do
      subject { described_class.new(value) }

      context "and it's a String" do
        let(:value) do
          <<~EOS
            foo bar
            baz qux
          EOS
        end

        it "must split the value into separate lines and populate #lines" do
          expect(subject.lines).to eq(value.lines(chomp: true))
        end
      end

      context "but it's not a String" do
        let(:value) { 42 }

        it "must convert it to a String before adding it to #lines" do
          expect(subject.lines).to eq([value.to_s])
        end
      end
    end
  end

  describe ".line_width" do
    subject { described_class }

    context "when given a plain-text String" do
      let(:line) { "foo bar baz" }

      it "must return the line length" do
        expect(subject.line_width(line)).to eq(line.length)
      end
    end

    context "when given a String containing ANSI control sequences" do
      let(:line_without_ansi) { "foo bar baz" }
      let(:line) { "\e[1m\e[32m#{line_without_ansi}\e[0m" }

      it "must return the length of the line without the ANSI control sequences" do
        expect(subject.line_width(line)).to eq(line_without_ansi.length)
      end
    end
  end

  describe "#<<" do
    let(:line) { "foo bar baz" }

    it "must increment #height by 1" do
      expect(subject.height).to eq(0)

      subject << line
      expect(subject.height).to eq(1)

      subject << line
      expect(subject.height).to eq(2)
    end

    it "must append the line to #lines" do
      subject << line

      expect(subject.lines.last).to eq(line)
    end

    it "must return self" do
      expect(subject << line).to be(subject)
    end

    context "when the line's line-width is greater than #width" do
      let(:previous_line) { "foo" }

      it "must update #width" do
        subject << previous_line
        expect(subject.width).to eq(previous_line.length)

        subject << line
        expect(subject.width).to eq(line.length)
      end
    end

    context "when the line's line-width is not greater than #width" do
      let(:previous_line) { "foo bar baz" }
      let(:line)          { "foo" }

      it "must update #width" do
        subject << previous_line
        expect(subject.width).to eq(previous_line.length)

        subject << line
        expect(subject.width).to eq(previous_line.length)
      end
    end
  end

  describe "#[]" do
    let(:line1) { "foo bar" }
    let(:line2) { "baz qux" }

    before do
      subject << line1
      subject << line2
    end

    context "when the index is within the bounds of #lines" do
      it "must return the line at the given index" do
        expect(subject[1]).to eq(line2)
      end
    end

    context "when the index is out of the bounds of #lines" do
      it "must return ''" do
        expect(subject[2]).to eq('')
      end
    end
  end
end
