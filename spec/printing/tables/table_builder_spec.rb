require 'spec_helper'
require 'command_kit/printing/tables/table_builder'

describe CommandKit::Printing::Tables::TableBuilder do
  it { expect(described_class).to include(Enumerable) }

  describe "#initialize" do
    it "must initialize #rows to an empty Array" do
      expect(subject.rows).to eq([])
    end

    it "must default #height to 0" do
      expect(subject.height).to eq(0)
    end

    it "must default #width to 0" do
      expect(subject.width).to eq(0)
    end

    it "must iniitialize #column_widths to an empty Array" do
      expect(subject.column_widths).to eq([])
    end

    it "must default #max_columns to 0" do
      expect(subject.max_columns).to eq(0)
    end

    it "must default #max_rows to 0" do
      expect(subject.max_rows).to eq(0)
    end

    context "when given initial rows" do
      let(:row1) { %w[foo bar]  }
      let(:row2) { %w[baz qux]  }
      let(:rows) { [row1, row2] }

      subject { described_class.new(rows) }

      it "must append the rows to the table" do
        expect(subject.rows[0]).to be_kind_of(CommandKit::Printing::Tables::RowBuilder)
        expect(subject.rows[0].cells[0].lines[0]).to eq(row1[0])
        expect(subject.rows[0].cells[1].lines[0]).to eq(row1[1])

        expect(subject.rows[1]).to be_kind_of(CommandKit::Printing::Tables::RowBuilder)
        expect(subject.rows[1].cells[0].lines[0]).to eq(row2[0])
        expect(subject.rows[1].cells[1].lines[0]).to eq(row2[1])
      end

      context "and when given the header: keyword argument" do
        let(:header) { %w[A B] }

        subject { described_class.new(rows, header: header) }

        it "must append the header: value before the rows" do
          expect(subject.rows[0]).to be_kind_of(CommandKit::Printing::Tables::RowBuilder)
          expect(subject.rows[0].cells[0].lines[0]).to eq(header[0])
          expect(subject.rows[0].cells[1].lines[0]).to eq(header[1])

          expect(subject.rows[1]).to be_kind_of(CommandKit::Printing::Tables::RowBuilder)
          expect(subject.rows[1].cells[0].lines[0]).to eq(row1[0])
          expect(subject.rows[1].cells[1].lines[0]).to eq(row1[1])

          expect(subject.rows[2]).to be_kind_of(CommandKit::Printing::Tables::RowBuilder)
          expect(subject.rows[2].cells[0].lines[0]).to eq(row2[0])
          expect(subject.rows[2].cells[1].lines[0]).to eq(row2[1])
        end
      end
    end
  end

  describe "#header?" do
    let(:header) { %w[A B] }
    let(:rows) do
      [
        %w[foo bar],
        %w[baz qux]
      ]
    end

    context "when initialized with the header: keyword argument" do
      subject { described_class.new(rows, header: header) }

      it "must return true" do
        expect(subject.header?).to be(true)
      end
    end

    context "when not initialized with the header: keyword argument" do
      it "must return false" do
        expect(subject.header?).to be(false)
      end
    end
  end

  describe "#<<" do
    let(:row) { %w[foo bar] }

    it "must append a new CommandKit::Printing::Tables::RowBuilder object to #rows" do
      subject << row

      expect(subject.rows.last).to be_kind_of(CommandKit::Printing::Tables::RowBuilder)
      expect(subject.rows.last.cells[0].lines[0]).to eq(row[0])
      expect(subject.rows.last.cells[1].lines[0]).to eq(row[1])
    end

    it "must increment #max_rows by 1" do
      expect(subject.max_rows).to eq(0)

      subject << row
      expect(subject.max_rows).to eq(1)

      subject << row
      expect(subject.max_rows).to eq(2)
    end

    it "must return self" do
      expect(subject << row).to be(subject)
    end

    context "when the row does contain any multi-line Strings" do
      let(:row1) { %w[foo bar] }
      let(:row2) { ["foo", "bar\nbaz"] }

      it "must increase #height by the line height of the new row" do
        expect(subject.height).to eq(0)

        subject << row1
        expect(subject.height).to eq(subject.rows.first.height)

        subject << row2
        expect(subject.height).to eq(
          subject.rows[0].height + subject.rows[1].height
        )
      end
    end

    context "when the row does not contain any multi-line Strings" do
      let(:row1) { %w[foo bar] }
      let(:row2) { %w[baz qux] }

      it "must increase #height by 1" do
        expect(subject.height).to eq(0)

        subject << row1
        expect(subject.height).to eq(1)

        subject << row2
        expect(subject.height).to eq(2)
      end
    end

    context "when the row contains more characters than the current #width" do
      let(:row1) { %w[foo bar] }
      let(:row2) { %w[foo barAAAAAAAA] }

      it "must update #width to the new row's width" do
        expect(subject.width).to eq(0)

        subject << row1
        expect(subject.width).to eq(subject.rows[0].width)

        subject << row2
        expect(subject.width).to eq(subject.rows[1].width)
      end
    end

    context "when the row does not contains more characters than #width" do
      let(:row1) { %w[foo bar] }
      let(:row2) { %w[foo bar] }

      it "must not update #width" do
        expect(subject.width).to eq(0)

        subject << row1
        expect(subject.width).to eq(subject.rows[0].width)

        subject << row2
        expect(subject.width).to eq(subject.rows[0].width)
      end
    end

    context "when the row contains more columns than the current #max_columns" do
      let(:row1) { %w[foo bar] }
      let(:row2) { %w[foo bar qux] }

      it "must update #max_columns to the new row's #columns" do
        expect(subject.max_columns).to eq(0)

        subject << row1
        expect(subject.max_columns).to eq(subject.rows[0].columns)

        subject << row2
        expect(subject.max_columns).to eq(subject.rows[1].columns)
      end
    end

    context "when the row does not contain more columns than the current #max_columns" do
      let(:row1) { %w[foo bar] }
      let(:row2) { %w[foo bar] }

      it "must not update #max_columns" do
        expect(subject.max_columns).to eq(0)

        subject << row1
        expect(subject.max_columns).to eq(subject.rows[0].columns)

        subject << row2
        expect(subject.max_columns).to eq(subject.rows[0].columns)
      end
    end
  end

  describe "#[]" do
    context "when the row index is within the bounds of #rows" do
      before do
        subject << %w[foo bar]
        subject << %w[baz qux]
      end

      it "must return the row at the given index" do
        expect(subject[1]).to be(subject.rows[1])
      end
    end

    context "when the row index is not within the bounds of #rows" do
      it "must return nil" do
        expect(subject[2]).to be(nil)
      end
    end
  end

  describe "#each" do
    before do
      subject << %w[foo bar]
      subject << %w[baz qux]
    end

    context "when given a block" do
      it "must yield each row in #rows" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*subject.rows)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for #rows" do
        expect(subject.each.to_a).to eq(subject.rows)
      end
    end
  end
end
