require 'spec_helper'
require 'command_kit/printing/tables/table_formatter'
require 'command_kit/printing/tables/table_builder'
require 'command_kit/printing/tables/style'

describe CommandKit::Printing::Tables::TableFormatter do
  let(:header) { ['A', 'B', 'C'] }
  let(:rows) do
    [
      ['AAAA', 'BBBB', 'CCCC'],
      ['DDDD', 'EEEE', 'FFFF'],
      ['GGGG', 'HHHH', 'IIII']
    ]
  end
  let(:multiline_rows) do
    [
      ["AAAA\nAA", "BBBB",    "CCCC"],
      ["DDDD",    "EEEE\nEE", "FFFF"],
      ["GGGG",    "HHHH",     "IIII\nII"]
    ]
  end
  let(:rows_with_empty_cells) do
    [
      [nil,    'BBBB', 'CCCC'],
      ['DDDD', nil,    'FFFF'],
      ['GGGG', 'HHHH', nil   ]
    ]
  end
  let(:rows_with_diff_row_lengths) do
    [
      ['AAAA'],
      ['DDDD', 'EEEE'],
      ['GGGG', 'HHHH', 'IIII']
    ]
  end
  let(:unjustified_rows) do
    [
      ['AAAA', 'BBBB', 'CCCC'],
      ['DD',   'EE',   'FF'  ],
      ['G',    'H',    'I'   ]
    ]
  end

  let(:table) { CommandKit::Printing::Tables::TableBuilder.new(rows) }
  let(:style) { CommandKit::Printing::Tables::Style.new }

  subject { described_class.new(table,style) }

  describe "#format" do
    it "must yield each line of the table with 1 space padding and no borders" do
      expect { |b|
        subject.format(&b)
      }.to yield_successive_args(
        " AAAA  BBBB  CCCC ",
        " DDDD  EEEE  FFFF ",
        " GGGG  HHHH  IIII "
      )
    end

    context "but when the table contains multi-line cells" do
      let(:rows) { multiline_rows }

      it "must yield each line of each row" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          " AAAA  BBBB  CCCC ",
          " AA               ",
          " DDDD  EEEE  FFFF ",
          "       EE         ",
          " GGGG  HHHH  IIII ",
          "             II   "
        )
      end
    end

    context "but when the table contains empty cells" do
      let(:rows) { rows_with_empty_cells }

      it "must replace the empty cells with spaces" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          "       BBBB  CCCC ",
          " DDDD        FFFF ",
          " GGGG  HHHH       "
        )
      end
    end

    context "but when the table contains empty cells" do
      let(:rows) { rows_with_diff_row_lengths }

      it "must pad the columns with empty cells" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          " AAAA             ",
          " DDDD  EEEE       ",
          " GGGG  HHHH  IIII "
        )
      end
    end

    context "when the #style.separate_rows? is true" do
      let(:style) do
        CommandKit::Printing::Tables::Style.new(separate_rows: true)
      end

      it "must yield the rows with blank lines between each row" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          " AAAA  BBBB  CCCC ",
          "",
          " DDDD  EEEE  FFFF ",
          "",
          " GGGG  HHHH  IIII "
        )
      end
    end

    context "and when #style.justify is :left" do
      let(:rows) { unjustified_rows }
      let(:style) do
        CommandKit::Printing::Tables::Style.new(justify: :left)
      end

      it "must left justify each cell" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          " AAAA  BBBB  CCCC ",
          " DD    EE    FF   ",
          " G     H     I    "
        )
      end
    end

    context "and when #style.justify is :right" do
      let(:rows) { unjustified_rows }
      let(:style) do
        CommandKit::Printing::Tables::Style.new(justify: :right)
      end

      it "must right justify each cell" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          " AAAA  BBBB  CCCC ",
          "   DD    EE    FF ",
          "    G     H     I "
        )
      end
    end

    context "and when #style.justify is :center" do
      let(:rows) { unjustified_rows }
      let(:style) do
        CommandKit::Printing::Tables::Style.new(justify: :center)
      end

      it "must center justify each cell" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          " AAAA  BBBB  CCCC ",
          "  DD    EE    FF  ",
          "  G     H     I   "
        )
      end
    end

    context "and when #table.header? is true" do
      let(:table) do
        CommandKit::Printing::Tables::TableBuilder.new(rows, header: header)
      end

      it "must yield the center justified header row, then a blank line, then the rest of the rows" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          "  A     B     C   ",
          "",
          " AAAA  BBBB  CCCC ",
          " DDDD  EEEE  FFFF ",
          " GGGG  HHHH  IIII "
        )
      end

      context "and #style.separate_rows? is true" do
        let(:style) do
          CommandKit::Printing::Tables::Style.new(separate_rows: true)
        end

        it "must yield the header, a blank line, then the rows with blaink lines between each row" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "  A     B     C   ",
            "",
            " AAAA  BBBB  CCCC ",
            "",
            " DDDD  EEEE  FFFF ",
            "",
            " GGGG  HHHH  IIII ",
          )
        end
      end

      context "and when #style.justify_header is :left" do
        let(:style) do
          CommandKit::Printing::Tables::Style.new(justify_header: :left)
        end

        it "must left justify the header cells" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            " A     B     C    ",
            "",
            " AAAA  BBBB  CCCC ",
            " DDDD  EEEE  FFFF ",
            " GGGG  HHHH  IIII ",
          )
        end
      end

      context "and when #style.justify_header is :right" do
        let(:style) do
          CommandKit::Printing::Tables::Style.new(justify_header: :right)
        end

        it "must right justify the header cells" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "    A     B     C ",
            "",
            " AAAA  BBBB  CCCC ",
            " DDDD  EEEE  FFFF ",
            " GGGG  HHHH  IIII "
          )
        end
      end

      context "and when #style.justify_header is :center" do
        let(:style) do
          CommandKit::Printing::Tables::Style.new(justify_header: :center)
        end

        it "must center justify the header cells" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "  A     B     C   ",
            "",
            " AAAA  BBBB  CCCC ",
            " DDDD  EEEE  FFFF ",
            " GGGG  HHHH  IIII "
          )
        end
      end

      context "and when #style.justify is :left" do
        let(:rows) { unjustified_rows }
        let(:style) do
          CommandKit::Printing::Tables::Style.new(justify: :left)
        end

        it "must left justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "  A     B     C   ",
            "",
            " AAAA  BBBB  CCCC ",
            " DD    EE    FF   ",
            " G     H     I    ",
          )
        end
      end

      context "and when #style.justify is :right" do
        let(:rows) { unjustified_rows }
        let(:style) do
          CommandKit::Printing::Tables::Style.new(justify: :right)
        end

        it "must right justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "  A     B     C   ",
            "",
            " AAAA  BBBB  CCCC ",
            "   DD    EE    FF ",
            "    G     H     I "
          )
        end
      end

      context "and when #style.justify is :center" do
        let(:rows) { unjustified_rows }
        let(:style) do
          CommandKit::Printing::Tables::Style.new(justify: :center)
        end

        it "must center justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "  A     B     C   ",
            "",
            " AAAA  BBBB  CCCC ",
            "  DD    EE    FF  ",
            "  G     H     I   "
          )
        end
      end
    end

    context "when #style.border is :ascii" do
      let(:style) do
        CommandKit::Printing::Tables::Style.new(border: :ascii)
      end

      it "must yield each row with an ASCII border" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          "+------+------+------+",
          "| AAAA | BBBB | CCCC |",
          "| DDDD | EEEE | FFFF |",
          "| GGGG | HHHH | IIII |",
          "+------+------+------+",
        )
      end

      context "but when the table contains multi-line cells" do
        let(:rows) { multiline_rows }

        it "must yield each line of each row" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "+------+------+------+",
            "| AAAA | BBBB | CCCC |",
            "| AA   |      |      |",
            "| DDDD | EEEE | FFFF |",
            "|      | EE   |      |",
            "| GGGG | HHHH | IIII |",
            "|      |      | II   |",
            "+------+------+------+",
          )
        end
      end

      context "but when the table contains empty cells" do
        let(:rows) { rows_with_empty_cells }

        it "must replace the empty cells with spaces" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "+------+------+------+",
            "|      | BBBB | CCCC |",
            "| DDDD |      | FFFF |",
            "| GGGG | HHHH |      |",
            "+------+------+------+",
          )
        end
      end

      context "but when the table contains empty cells" do
        let(:rows) { rows_with_diff_row_lengths }

        it "must pad the columns with empty cells" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "+------+------+------+",
            "| AAAA |      |      |",
            "| DDDD | EEEE |      |",
            "| GGGG | HHHH | IIII |",
            "+------+------+------+",
          )
        end
      end

      context "and when #style.separate_rows is true" do
        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:        :ascii,
            separate_rows: true
          )
        end

        it "must yield each row with a separator line between each row" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "+------+------+------+",
            "| AAAA | BBBB | CCCC |",
            "+------+------+------+",
            "| DDDD | EEEE | FFFF |",
            "+------+------+------+",
            "| GGGG | HHHH | IIII |",
            "+------+------+------+",
          )
        end
      end

      context "and when #style.justify is :left" do
        let(:rows) { unjustified_rows }

        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:  :ascii,
            justify: :left
          )
        end

        it "must left justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "+------+------+------+",
            "| AAAA | BBBB | CCCC |",
            "| DD   | EE   | FF   |",
            "| G    | H    | I    |",
            "+------+------+------+",
          )
        end
      end

      context "and when #style.justify is :right" do
        let(:rows) { unjustified_rows }

        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:  :ascii,
            justify: :right
          )
        end

        it "must right justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "+------+------+------+",
            "| AAAA | BBBB | CCCC |",
            "|   DD |   EE |   FF |",
            "|    G |    H |    I |",
            "+------+------+------+",
          )
        end
      end

      context "and when #style.justify is :center" do
        let(:rows) { unjustified_rows }

        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:  :ascii,
            justify: :center
          )
        end

        it "must center justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "+------+------+------+",
            "| AAAA | BBBB | CCCC |",
            "|  DD  |  EE  |  FF  |",
            "|  G   |  H   |  I   |",
            "+------+------+------+",
          )
        end
      end

      context "and when #table.header? is true" do
        let(:table) do
          CommandKit::Printing::Tables::TableBuilder.new(rows, header: header)
        end

        it "must yield the center justified header row, then a separator line, then the table" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "+------+------+------+",
            "|  A   |  B   |  C   |",
            "+------+------+------+",
            "| AAAA | BBBB | CCCC |",
            "| DDDD | EEEE | FFFF |",
            "| GGGG | HHHH | IIII |",
            "+------+------+------+",
          )
        end

        context "and when #style.separate_rows? is true" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:        :ascii,
              separate_rows: true
            )
          end

          it "must yield the header and rows with separator lines between each row" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "+------+------+------+",
              "|  A   |  B   |  C   |",
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "+------+------+------+",
              "| DDDD | EEEE | FFFF |",
              "+------+------+------+",
              "| GGGG | HHHH | IIII |",
              "+------+------+------+",
            )
          end
        end

        context "and when #style.justify_header is :left" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:         :ascii,
              justify_header: :left
            )
          end

          it "must left justify the header cells" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "+------+------+------+",
              "| A    | B    | C    |",
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "| DDDD | EEEE | FFFF |",
              "| GGGG | HHHH | IIII |",
              "+------+------+------+",
            )
          end
        end

        context "and when #style.justify_header is :right" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:         :ascii,
              justify_header: :right
            )
          end

          it "must right justify the header cells" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "+------+------+------+",
              "|    A |    B |    C |",
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "| DDDD | EEEE | FFFF |",
              "| GGGG | HHHH | IIII |",
              "+------+------+------+",
            )
          end
        end

        context "and when #style.justify_header is :center" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:         :ascii,
              justify_header: :center
            )
          end

          it "must center justify the header cells" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "+------+------+------+",
              "|  A   |  B   |  C   |",
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "| DDDD | EEEE | FFFF |",
              "| GGGG | HHHH | IIII |",
              "+------+------+------+",
            )
          end
        end
      end
    end

    context "when #style.border is :line" do
      let(:style) do
        CommandKit::Printing::Tables::Style.new(border: :line)
      end

      it "must yield the table with an ANSI line border" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          "┌──────┬──────┬──────┐",
          "│ AAAA │ BBBB │ CCCC │",
          "│ DDDD │ EEEE │ FFFF │",
          "│ GGGG │ HHHH │ IIII │",
          "└──────┴──────┴──────┘"
        )
      end

      context "but when the table contains multi-line cells" do
        let(:rows) { multiline_rows }

        it "must yield each line of each row" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "┌──────┬──────┬──────┐",
            "│ AAAA │ BBBB │ CCCC │",
            "│ AA   │      │      │",
            "│ DDDD │ EEEE │ FFFF │",
            "│      │ EE   │      │",
            "│ GGGG │ HHHH │ IIII │",
            "│      │      │ II   │",
            "└──────┴──────┴──────┘",
          )
        end
      end

      context "but when the table contains empty cells" do
        let(:rows) { rows_with_empty_cells }

        it "must replace the empty cells with spaces" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "┌──────┬──────┬──────┐",
            "│      │ BBBB │ CCCC │",
            "│ DDDD │      │ FFFF │",
            "│ GGGG │ HHHH │      │",
            "└──────┴──────┴──────┘",
          )
        end
      end

      context "but when the table contains empty cells" do
        let(:rows) { rows_with_diff_row_lengths }

        it "must pad the columns with empty cells" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "┌──────┬──────┬──────┐",
            "│ AAAA │      │      │",
            "│ DDDD │ EEEE │      │",
            "│ GGGG │ HHHH │ IIII │",
            "└──────┴──────┴──────┘",
          )
        end
      end

      context "and when #style.separate_rows is true" do
        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:        :line,
            separate_rows: true
          )
        end

        it "must yield each row with separator lines between each row" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "┌──────┬──────┬──────┐",
            "│ AAAA │ BBBB │ CCCC │",
            "├──────┼──────┼──────┤",
            "│ DDDD │ EEEE │ FFFF │",
            "├──────┼──────┼──────┤",
            "│ GGGG │ HHHH │ IIII │",
            "└──────┴──────┴──────┘",
          )
        end
      end

      context "and when #style.justify is :left" do
        let(:rows) { unjustified_rows }

        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:  :line,
            justify: :left
          )
        end

        it "must left justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "┌──────┬──────┬──────┐",
            "│ AAAA │ BBBB │ CCCC │",
            "│ DD   │ EE   │ FF   │",
            "│ G    │ H    │ I    │",
            "└──────┴──────┴──────┘",
          )
        end
      end

      context "and when #style.justify is :right" do
        let(:rows) { unjustified_rows }

        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:  :line,
            justify: :right
          )
        end

        it "must right justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "┌──────┬──────┬──────┐",
            "│ AAAA │ BBBB │ CCCC │",
            "│   DD │   EE │   FF │",
            "│    G │    H │    I │",
            "└──────┴──────┴──────┘",
          )
        end
      end

      context "and when #style.justify is :center" do
        let(:rows) { unjustified_rows }

        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:  :line,
            justify: :center
          )
        end

        it "must center justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "┌──────┬──────┬──────┐",
            "│ AAAA │ BBBB │ CCCC │",
            "│  DD  │  EE  │  FF  │",
            "│  G   │  H   │  I   │",
            "└──────┴──────┴──────┘",
          )
        end
      end

      context "and when #style.header is true" do
        let(:table) do
          CommandKit::Printing::Tables::TableBuilder.new(rows, header: header)
        end

        it "must yield the center justified header row, then a separator line, then the rows" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "┌──────┬──────┬──────┐",
            "│  A   │  B   │  C   │",
            "├──────┼──────┼──────┤",
            "│ AAAA │ BBBB │ CCCC │",
            "│ DDDD │ EEEE │ FFFF │",
            "│ GGGG │ HHHH │ IIII │",
            "└──────┴──────┴──────┘",
          )
        end

        context "and when #style.separate_rows is true" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:        :line,
              separate_rows: true
            )
          end

          it "must yield the header and each row with a separator line between each row" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "┌──────┬──────┬──────┐",
              "│  A   │  B   │  C   │",
              "├──────┼──────┼──────┤",
              "│ AAAA │ BBBB │ CCCC │",
              "├──────┼──────┼──────┤",
              "│ DDDD │ EEEE │ FFFF │",
              "├──────┼──────┼──────┤",
              "│ GGGG │ HHHH │ IIII │",
              "└──────┴──────┴──────┘",
            )
          end
        end

        context "and when #style.justify_header is :left" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:         :line,
              justify_header: :left
            )
          end

          it "must left justify the header cells" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "┌──────┬──────┬──────┐",
              "│ A    │ B    │ C    │",
              "├──────┼──────┼──────┤",
              "│ AAAA │ BBBB │ CCCC │",
              "│ DDDD │ EEEE │ FFFF │",
              "│ GGGG │ HHHH │ IIII │",
              "└──────┴──────┴──────┘",
            )
          end
        end

        context "and when #style.justify_header is :right" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:         :line,
              justify_header: :right
            )
          end

          it "must right justify the header cells" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "┌──────┬──────┬──────┐",
              "│    A │    B │    C │",
              "├──────┼──────┼──────┤",
              "│ AAAA │ BBBB │ CCCC │",
              "│ DDDD │ EEEE │ FFFF │",
              "│ GGGG │ HHHH │ IIII │",
              "└──────┴──────┴──────┘",
            )
          end
        end

        context "and when #style.justify_header is :center" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:         :line,
              justify_header: :center
            )
          end

          it "must center justify the header cells" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "┌──────┬──────┬──────┐",
              "│  A   │  B   │  C   │",
              "├──────┼──────┼──────┤",
              "│ AAAA │ BBBB │ CCCC │",
              "│ DDDD │ EEEE │ FFFF │",
              "│ GGGG │ HHHH │ IIII │",
              "└──────┴──────┴──────┘",
            )
          end
        end
      end
    end

    context "when #style.border is :double_line" do
      let(:style) do
        CommandKit::Printing::Tables::Style.new(border: :double_line)
      end

      it "must yield the table with an ANSI double-line border" do
        expect { |b|
          subject.format(&b)
        }.to yield_successive_args(
          "╔══════╦══════╦══════╗",
          "║ AAAA ║ BBBB ║ CCCC ║",
          "║ DDDD ║ EEEE ║ FFFF ║",
          "║ GGGG ║ HHHH ║ IIII ║",
          "╚══════╩══════╩══════╝",
        )
      end

      context "but when the table contains multi-line cells" do
        let(:rows) { multiline_rows }

        it "must yield each line of each row" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "╔══════╦══════╦══════╗",
            "║ AAAA ║ BBBB ║ CCCC ║",
            "║ AA   ║      ║      ║",
            "║ DDDD ║ EEEE ║ FFFF ║",
            "║      ║ EE   ║      ║",
            "║ GGGG ║ HHHH ║ IIII ║",
            "║      ║      ║ II   ║",
            "╚══════╩══════╩══════╝",
          )
        end
      end

      context "but when the table contains empty cells" do
        let(:rows) { rows_with_empty_cells }

        it "must replace the empty cells with spaces" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "╔══════╦══════╦══════╗",
            "║      ║ BBBB ║ CCCC ║",
            "║ DDDD ║      ║ FFFF ║",
            "║ GGGG ║ HHHH ║      ║",
            "╚══════╩══════╩══════╝",
          )
        end
      end

      context "but when the table contains empty cells" do
        let(:rows) { rows_with_diff_row_lengths }

        it "must pad the columns with empty cells" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "╔══════╦══════╦══════╗",
            "║ AAAA ║      ║      ║",
            "║ DDDD ║ EEEE ║      ║",
            "║ GGGG ║ HHHH ║ IIII ║",
            "╚══════╩══════╩══════╝",
          )
        end
      end

      context "and when #style.separate_rows is true" do
        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:        :double_line,
            separate_rows: true
          )
        end

        it "must yield each row with separator lines between each row" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "╔══════╦══════╦══════╗",
            "║ AAAA ║ BBBB ║ CCCC ║",
            "╠══════╬══════╬══════╣",
            "║ DDDD ║ EEEE ║ FFFF ║",
            "╠══════╬══════╬══════╣",
            "║ GGGG ║ HHHH ║ IIII ║",
            "╚══════╩══════╩══════╝",
          )
        end
      end

      context "and when #style.justify is :left" do
        let(:rows) { unjustified_rows }

        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:  :double_line,
            justify: :left
          )
        end

        it "must left justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "╔══════╦══════╦══════╗",
            "║ AAAA ║ BBBB ║ CCCC ║",
            "║ DD   ║ EE   ║ FF   ║",
            "║ G    ║ H    ║ I    ║",
            "╚══════╩══════╩══════╝",
          )
        end
      end

      context "and when #style.justify is :right" do
        let(:rows) { unjustified_rows }

        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:  :double_line,
            justify: :right
          )
        end

        it "must right justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "╔══════╦══════╦══════╗",
            "║ AAAA ║ BBBB ║ CCCC ║",
            "║   DD ║   EE ║   FF ║",
            "║    G ║    H ║    I ║",
            "╚══════╩══════╩══════╝",
          )
        end
      end

      context "and when #style.justify is :center" do
        let(:rows) { unjustified_rows }

        let(:style) do
          CommandKit::Printing::Tables::Style.new(
            border:  :double_line,
            justify: :center
          )
        end

        it "must center justify each cell" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "╔══════╦══════╦══════╗",
            "║ AAAA ║ BBBB ║ CCCC ║",
            "║  DD  ║  EE  ║  FF  ║",
            "║  G   ║  H   ║  I   ║",
            "╚══════╩══════╩══════╝",
          )
        end
      end

      context "and when #table.header? is true" do
        let(:table) do
          CommandKit::Printing::Tables::TableBuilder.new(rows, header: header)
        end

        it "must yield the center justified header row, then a separator line, then each row" do
          expect { |b|
            subject.format(&b)
          }.to yield_successive_args(
            "╔══════╦══════╦══════╗",
            "║  A   ║  B   ║  C   ║",
            "╠══════╬══════╬══════╣",
            "║ AAAA ║ BBBB ║ CCCC ║",
            "║ DDDD ║ EEEE ║ FFFF ║",
            "║ GGGG ║ HHHH ║ IIII ║",
            "╚══════╩══════╩══════╝",
          )
        end

        context "and when #style.separate_rows? is true" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:        :double_line,
              separate_rows: true
            )
          end

          it "must yield the header and each row with separator lines between them" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "╔══════╦══════╦══════╗",
              "║  A   ║  B   ║  C   ║",
              "╠══════╬══════╬══════╣",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "╠══════╬══════╬══════╣",
              "║ DDDD ║ EEEE ║ FFFF ║",
              "╠══════╬══════╬══════╣",
              "║ GGGG ║ HHHH ║ IIII ║",
              "╚══════╩══════╩══════╝",
            )
          end
        end

        context "and when #style.justify_header is :left" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:         :double_line,
              justify_header: :left
            )
          end

          it "must left justify the header cells" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "╔══════╦══════╦══════╗",
              "║ A    ║ B    ║ C    ║",
              "╠══════╬══════╬══════╣",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "║ DDDD ║ EEEE ║ FFFF ║",
              "║ GGGG ║ HHHH ║ IIII ║",
              "╚══════╩══════╩══════╝",
            )
          end
        end

        context "and when #style.justify_header is :right" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:         :double_line,
              justify_header: :right
            )
          end

          it "must right justify the header cells" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "╔══════╦══════╦══════╗",
              "║    A ║    B ║    C ║",
              "╠══════╬══════╬══════╣",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "║ DDDD ║ EEEE ║ FFFF ║",
              "║ GGGG ║ HHHH ║ IIII ║",
              "╚══════╩══════╩══════╝",
            )
          end
        end

        context "and when #style.justify_header is :center" do
          let(:style) do
            CommandKit::Printing::Tables::Style.new(
              border:         :double_line,
              justify_header: :center
            )
          end

          it "must center justify the header cells" do
            expect { |b|
              subject.format(&b)
            }.to yield_successive_args(
              "╔══════╦══════╦══════╗",
              "║  A   ║  B   ║  C   ║",
              "╠══════╬══════╬══════╣",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "║ DDDD ║ EEEE ║ FFFF ║",
              "║ GGGG ║ HHHH ║ IIII ║",
              "╚══════╩══════╩══════╝",
            )
          end
        end
      end
    end
  end
end
