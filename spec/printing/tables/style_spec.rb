require 'spec_helper'
require 'command_kit/printing/tables/style'

describe CommandKit::Printing::Tables::Style do
  describe "BORDER_STYLES" do
    subject { described_class::BORDER_STYLES }

    it "must be a Hash" do
      expect(subject).to be_kind_of(Hash)
    end

    describe ":ascii" do
      subject { super()[:ascii] }

      it "must be a CommandKit::Printing::Tables::BorderStyle" do
        expect(subject).to be_kind_of(CommandKit::Printing::Tables::BorderStyle)
      end

      it "must set #top_left_corner to '+'" do
        expect(subject.top_left_corner).to eq('+')
      end

      it "must set #top_border to '-'" do
        expect(subject.top_border).to eq('-')
      end

      it "must set #top_joined_border to '+'" do
        expect(subject.top_joined_border).to eq('+')
      end

      it "must set #top_right_corner to '+'" do
        expect(subject.top_right_corner).to eq('+')
      end

      it "must set #left_border to '|'" do
        expect(subject.left_border).to eq('|')
      end

      it "must set #left_joined_border to '+'" do
        expect(subject.left_joined_border).to eq('+')
      end

      it "must set #horizontal_separator to '-'" do
        expect(subject.horizontal_separator).to eq('-')
      end

      it "must set #vertical_separator to '|'" do
        expect(subject.vertical_separator).to eq('|')
      end

      it "must set #inner_joined_border to '+'" do
        expect(subject.inner_joined_border).to eq('+')
      end

      it "must set #right_border to '|'" do
        expect(subject.right_border).to eq('|')
      end

      it "must set #right_joined_border to '+'" do
        expect(subject.right_joined_border).to eq('+')
      end

      it "must set #bottom_border to '-'" do
        expect(subject.bottom_border).to eq('-')
      end

      it "must set #bottom_left_corner to '+'" do
        expect(subject.bottom_left_corner).to eq('+')
      end

      it "must set #bottom_joined_border to '+'" do
        expect(subject.bottom_joined_border).to eq('+')
      end

      it "must set #bottom_right_corner to '+'" do
        expect(subject.bottom_right_corner).to eq('+')
      end
    end

    describe ":line" do
      subject { super()[:line] }

      it "must be a CommandKit::Printing::Tables::BorderStyle" do
        expect(subject).to be_kind_of(CommandKit::Printing::Tables::BorderStyle)
      end

      it "must set #top_left_corner to '┌'" do
        expect(subject.top_left_corner).to eq('┌')
      end

      it "must set #top_border to '─'" do
        expect(subject.top_border).to eq('─')
      end

      it "must set #top_joined_border to '┬'" do
        expect(subject.top_joined_border).to eq('┬')
      end

      it "must set #top_right_corner to '┐'" do
        expect(subject.top_right_corner).to eq('┐')
      end

      it "must set #left_border to '│'" do
        expect(subject.left_border).to eq('│')
      end

      it "must set #left_joined_border to '├'" do
        expect(subject.left_joined_border).to eq('├')
      end

      it "must set #horizontal_separator to '─'" do
        expect(subject.horizontal_separator).to eq('─')
      end

      it "must set #vertical_separator to '│'" do
        expect(subject.vertical_separator).to eq('│')
      end

      it "must set #inner_joined_border to '┼'" do
        expect(subject.inner_joined_border).to eq('┼')
      end

      it "must set #right_border to '│'" do
        expect(subject.right_border).to eq('│')
      end

      it "must set #right_joined_border to '┤'" do
        expect(subject.right_joined_border).to eq('┤')
      end

      it "must set #bottom_border to '─'" do
        expect(subject.bottom_border).to eq('─')
      end

      it "must set #bottom_left_corner to '└'" do
        expect(subject.bottom_left_corner).to eq('└')
      end

      it "must set #bottom_joined_border to '┴'" do
        expect(subject.bottom_joined_border).to eq('┴')
      end

      it "must set #bottom_right_corner to '┘'" do
        expect(subject.bottom_right_corner).to eq('┘')
      end
    end

    describe ":double_line" do
      subject { super()[:double_line] }

      it "must be a CommandKit::Printing::Tables::BorderStyle" do
        expect(subject).to be_kind_of(CommandKit::Printing::Tables::BorderStyle)
      end

      it "must set #top_left_corner to '╔'" do
        expect(subject.top_left_corner).to eq('╔')
      end

      it "must set #top_border to '═'" do
        expect(subject.top_border).to eq('═')
      end

      it "must set #top_joined_border to '╦'" do
        expect(subject.top_joined_border).to eq('╦')
      end

      it "must set #top_right_corner to '╗'" do
        expect(subject.top_right_corner).to eq('╗')
      end

      it "must set #left_border to '║'" do
        expect(subject.left_border).to eq('║')
      end

      it "must set #left_joined_border to '╠'" do
        expect(subject.left_joined_border).to eq('╠')
      end

      it "must set #horizontal_separator to '═'" do
        expect(subject.horizontal_separator).to eq('═')
      end

      it "must set #vertical_separator to '║'" do
        expect(subject.vertical_separator).to eq('║')
      end

      it "must set #inner_joined_border to '╬'" do
        expect(subject.inner_joined_border).to eq('╬')
      end

      it "must set #right_border to '║'" do
        expect(subject.right_border).to eq('║')
      end

      it "must set #right_joined_border to '╣'" do
        expect(subject.right_joined_border).to eq('╣')
      end

      it "must set #bottom_border to '═'" do
        expect(subject.bottom_border).to eq('═')
      end

      it "must set #bottom_left_corner to '╚'" do
        expect(subject.bottom_left_corner).to eq('╚')
      end

      it "must set #bottom_joined_border to '╩'" do
        expect(subject.bottom_joined_border).to eq('╩')
      end

      it "must set #bottom_right_corner to '╝'" do
        expect(subject.bottom_right_corner).to eq('╝')
      end
    end
  end

  describe "#initialize" do
    it "must default #border to nil" do
      expect(subject.border).to be(nil)
    end

    it "must default #padding to 1" do
      expect(subject.padding).to be(1)
    end

    it "must default #justify to :left" do
      expect(subject.justify).to be(:left)
    end

    it "must default #justify_header to :center" do
      expect(subject.justify_header).to be(:center)
    end

    it "must default #separate_rows to false" do
      expect(subject.separate_rows).to eq(false)
    end

    context "when given the border: keyword argument" do
      context "and it's a Hash" do
        let(:hash) do
          {
           top_left_corner:      '=',
           top_border:           '=',
           top_joined_border:    '=',
           top_right_corner:     '=',
           bottom_left_corner:   '=',
           bottom_border:        '=',
           bottom_joined_border: '=',
           bottom_right_corner:  '='
          }
        end

        subject { described_class.new(border: hash) }

        it "must initialize #border to a new CommandKit::Printing::Tables::BorderStyle" do
          expect(subject.border).to be_kind_of(CommandKit::Printing::Tables::BorderStyle)
          expect(subject.border.top_left_corner).to eq('=')
          expect(subject.border.top_border).to eq('=')
          expect(subject.border.top_joined_border).to eq('=')
          expect(subject.border.top_right_corner).to eq('=')
          expect(subject.border.bottom_left_corner).to eq('=')
          expect(subject.border.bottom_border).to eq('=')
          expect(subject.border.bottom_joined_border).to eq('=')
          expect(subject.border.bottom_right_corner).to eq('=')
        end
      end

      context "and it's :ascii" do
        subject { described_class.new(border: :ascii) }

        it "must set #border to BORDER_STYLES[:ascii]" do
          expect(subject.border).to be(described_class::BORDER_STYLES[:ascii])
        end
      end

      context "and it's :line" do
        subject { described_class.new(border: :line) }

        it "must set #border to BORDER_STYLES[:line]" do
          expect(subject.border).to be(described_class::BORDER_STYLES[:line])
        end
      end

      context "and it's :double_line" do
        subject { described_class.new(border: :double_line) }

        it "must set #border to BORDER_STYLES[:double_line]" do
          expect(subject.border).to be(described_class::BORDER_STYLES[:double_line])
        end
      end

      context "but it's an unknwon Symbol" do
        let(:border) { :foo }

        it do
          expect {
            described_class.new(border: border)
          }.to raise_error(ArgumentError,"unknown border style (#{border.inspect}) must be either :ascii, :line, :double_line")
        end
      end

      context "and it's nil" do
        subject { described_class.new(border: nil) }

        it "must set #border to nil" do
          expect(subject.border).to be(nil)
        end
      end

      context "but it's not a Symbol, Hash, or nil" do
        let(:border) { Object.new }

        it do
          expect {
            described_class.new(border: border)
          }.to raise_error(ArgumentError,"invalid border value (#{border.inspect}) must be either :ascii, :line, :double_line, Hash, or nil")
        end
      end
    end

    context "when given the padding: keyword argument" do
      let(:padding) { 2 }

      subject { described_class.new(padding: padding) }

      it "must set #padding" do
        expect(subject.padding).to eq(padding)
      end
    end

    context "when given the justify: keyword argument" do
      let(:justify) { :center }

      subject { described_class.new(justify: justify) }

      it "must set #justify" do
        expect(subject.justify).to eq(justify)
      end
    end

    context "when given the justify: keyword argument" do
      let(:justify_header) { :left }

      subject { described_class.new(justify_header: justify_header) }

      it "must set #justify_header" do
        expect(subject.justify_header).to eq(justify_header)
      end
    end

    context "when given the separate_rows: keyword argument" do
      let(:separate_rows) { true }

      subject { described_class.new(separate_rows: separate_rows) }

      it "must set #separate_rows" do
        expect(subject.separate_rows).to eq(separate_rows)
      end
    end
  end

  describe "#separate_rows?" do
    context "when initialized with separate_rows: true" do
      subject { described_class.new(separate_rows: true) }

      it "must return true" do
        expect(subject.separate_rows?).to be(true)
      end
    end

    context "when not initialized with separate_rows: true" do
      it "must return false" do
        expect(subject.separate_rows?).to be(false)
      end
    end
  end
end
