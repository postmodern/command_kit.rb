require 'spec_helper'
require 'command_kit/printing/tables/row_builder'

describe CommandKit::Printing::Tables::RowBuilder do
  it { expect(described_class).to include(Enumerable) }

  describe "#initialize" do
    it "must initialize #cells to an empty Array" do
      expect(subject.cells).to eq([])
    end

    it "must default #height to 0" do
      expect(subject.height).to eq(0)
    end

    it "must default #width to 0" do
      expect(subject.width).to eq(0)
    end

    it "must default #columns to 0" do
      expect(subject.columns).to eq(0)
    end

    context "when given initial cells" do
      let(:cell1) { "foo bar\nbaz qux" }
      let(:cell2) { 'aaaa bbbb' }
      let(:cells) { [cell1, cell2] }

      subject { described_class.new(cells) }

      it "must append the cells to the row" do
        expect(subject.cells[0]).to be_kind_of(CommandKit::Printing::Tables::CellBuilder)
        expect(subject.cells[0].lines).to eq(cell1.lines(chomp: true))

        expect(subject.cells[1]).to be_kind_of(CommandKit::Printing::Tables::CellBuilder)
        expect(subject.cells[1].lines).to eq(cell2.lines(chomp: true))
      end
    end
  end

  describe "#<<" do
    context "when given a non-nil value" do
      let(:value) { "foo bar\nbaz qux" }

      it "must append a new CommandKit::Printing::Tables::CellBuilder object to #cells" do
        subject << value

        expect(subject.cells.last).to be_kind_of(CommandKit::Printing::Tables::CellBuilder)
        expect(subject.cells.last.lines).to eq(value.lines(chomp: true))
      end

      context "when the new cell's height is greater than the row's current #height" do
        let(:value1) { "foo" }
        let(:value2) { "bar\nbaz\nqux" }

        it "must update the row's current #height" do
          expect(subject.height).to eq(0)

          subject << value1
          expect(subject.height).to eq(subject.cells[0].height)

          subject << value2
          expect(subject.height).to eq(subject.cells[1].height)
        end
      end

      context "when the new cell's height is not greater than the row's current #height" do
        let(:value1) { "bar\nbaz\nqux" }
        let(:value2) { "foo" }

        it "must not update the row's current #height" do
          expect(subject.height).to eq(0)

          subject << value1
          expect(subject.height).to eq(subject.cells[0].height)

          subject << value2
          expect(subject.height).to eq(subject.cells[0].height)
        end
      end

      it "must add the cell value's line width to the row's #width" do
        value1 = "foo"
        value1_width = CommandKit::Printing::Tables::CellBuilder.line_width(value1)

        expect(subject.width).to eq(0)

        subject << value1
        expect(subject.width).to eq(value1_width)

        value2 = "\e[32mbar\e[0m"
        value2_width = CommandKit::Printing::Tables::CellBuilder.line_width(value2)

        subject << value2
        expect(subject.width).to eq(value1_width + value2_width)
      end

      it "must incrmenet #columns by 1" do
        expect(subject.columns).to eq(0)

        subject << "foo"
        expect(subject.columns).to eq(1)

        subject << "bar"
        expect(subject.columns).to eq(2)
      end

      it "must return self" do
        expect(subject << value).to be(subject)
      end
    end

    context "when given a nil value" do
      it "must append #{described_class}::EMPTY_CELL to #cells" do
        subject << nil

        expect(subject.cells.last).to be(described_class::EMPTY_CELL)
      end

      it "must return self" do
        expect(subject << nil).to be(subject)
      end
    end
  end

  describe "#[]" do
    before do
      subject << "foo bar"
      subject << "baz qux"
    end

    context "when the given column index is within the bounds of #cells" do
      it "must return the cell at the given index" do
        expect(subject[1]).to be(subject.cells[1])
      end
    end

    context "when the given column index is not within the bounds of #cells" do
      it "must return #{described_class}::EMPTY_CELL" do
        expect(subject[2]).to be(described_class::EMPTY_CELL)
      end
    end
  end

  describe "#each" do
    before do
      subject << "foo bar"
      subject << "baz qux"
    end

    context "when given a block" do
      it "must yield each cell in #cells" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*subject.cells)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for #cells" do
        expect(subject.each.to_a).to eq(subject.cells)
      end
    end
  end
end
