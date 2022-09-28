require 'spec_helper'
require 'command_kit/printing/tables'

require 'stringio'

describe CommandKit::Printing::Tables do
  module TestPrintingTables
    class TestCmd

      include CommandKit::Printing::Tables

    end
  end

  let(:command_class) { TestPrintingTables::TestCmd }
  subject { command_class.new }
 
  describe "#print_table" do
    let(:header) { ['A', 'B', 'C'] }
    let(:table) do
      [
        ['AAAA', 'BBBB', 'CCCC'],
        ['DDDD', 'EEEE', 'FFFF'],
        ['GGGG', 'HHHH', 'IIII']
      ]
    end
    let(:multiline_table) do
      [
        ["AAAA\nAA", "BBBB",    "CCCC"],
        ["DDDD",    "EEEE\nEE", "FFFF"],
        ["GGGG",    "HHHH",     "IIII\nII"]
      ]
    end
    let(:table_with_empty_cells) do
      [
        [nil,    'BBBB', 'CCCC'],
        ['DDDD', nil,    'FFFF'],
        ['GGGG', 'HHHH', nil   ]
      ]
    end
    let(:table_with_diff_row_lengths) do
      [
        ['AAAA'],
        ['DDDD', 'EEEE'],
        ['GGGG', 'HHHH', 'IIII']
      ]
    end
    let(:unjustified_table) do
      [
        ['AAAA', 'BBBB', 'CCCC'],
        ['DD',   'EE',   'FF'  ],
        ['G',    'H',    'I'   ]
      ]
    end

    context "when no keyword arguments are given" do
      it "must print the table with 1 space padding and no borders" do
        expect {
          subject.print_table(table)
        }.to output(
          [
            " AAAA  BBBB  CCCC ",
            " DDDD  EEEE  FFFF ",
            " GGGG  HHHH  IIII ",
            ''
          ].join($/)
        ).to_stdout
      end

      context "but when the table contains multi-line cells" do
        it "must print each line of each row" do
          expect {
            subject.print_table(multiline_table)
          }.to output(
            [
              " AAAA  BBBB  CCCC ",
              " AA               ",
              " DDDD  EEEE  FFFF ",
              "       EE         ",
              " GGGG  HHHH  IIII ",
              "             II   ",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "but when the table contains empty cells" do
        it "must replace the empty cells with spaces" do
          expect {
            subject.print_table(table_with_empty_cells)
          }.to output(
            [
              "       BBBB  CCCC ",
              " DDDD        FFFF ",
              " GGGG  HHHH       ",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "but when the table contains empty cells" do
        it "must pad the columns with empty cells" do
          expect {
            subject.print_table(table_with_diff_row_lengths)
          }.to output(
            [
              " AAAA             ",
              " DDDD  EEEE       ",
              " GGGG  HHHH  IIII ",
              ''
            ].join($/)
          ).to_stdout
        end
      end
    end

    context "and when `separate_rows: true` is given" do
      it "must print each row with blank lines between each row" do
        expect {
          subject.print_table(table, separate_rows: true)
        }.to output(
          [
            " AAAA  BBBB  CCCC ",
            "",
            " DDDD  EEEE  FFFF ",
            "",
            " GGGG  HHHH  IIII ",
            ''
          ].join($/)
        ).to_stdout
      end
    end

    context "and when `justify: :left` is given" do
      it "must left justify each cell" do
        expect {
          subject.print_table(unjustified_table, justify: :left)
        }.to output(
          [
            " AAAA  BBBB  CCCC ",
            " DD    EE    FF   ",
            " G     H     I    ",
            ''
          ].join($/)
        ).to_stdout
      end
    end

    context "and when `justify: :right` is given" do
      it "must right justify each cell" do
        expect {
          subject.print_table(unjustified_table, justify: :right)
        }.to output(
          [
            " AAAA  BBBB  CCCC ",
            "   DD    EE    FF ",
            "    G     H     I ",
            ''
          ].join($/)
        ).to_stdout
      end
    end

    context "and when `justify: :center` is given" do
      it "must center justify each cell" do
        expect {
          subject.print_table(unjustified_table, justify: :center)
        }.to output(
          [
            " AAAA  BBBB  CCCC ",
            "  DD    EE    FF  ",
            "  G     H     I   ",
            ''
          ].join($/)
        ).to_stdout
      end
    end

    context "and when the header: keyword argument is given" do
      it "must print the center justified header row, then a blank line, then the table" do
        expect {
          subject.print_table(table, header: header)
        }.to output(
          [
            "  A     B     C   ",
            "",
            " AAAA  BBBB  CCCC ",
            " DDDD  EEEE  FFFF ",
            " GGGG  HHHH  IIII ",
            ''
          ].join($/)
        ).to_stdout
      end

      context "and when `separate_rows: true` is given" do
        it "must print the header and add blank lines between each row" do
          expect {
            subject.print_table(table, header: header, separate_rows: true)
          }.to output(
            [
              "  A     B     C   ",
              "",
              " AAAA  BBBB  CCCC ",
              "",
              " DDDD  EEEE  FFFF ",
              "",
              " GGGG  HHHH  IIII ",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify_header: :left` is given" do
        it "must left justify the header cells" do
          expect {
            subject.print_table(table, header: header, justify_header: :left)
          }.to output(
            [
              " A     B     C    ",
              "",
              " AAAA  BBBB  CCCC ",
              " DDDD  EEEE  FFFF ",
              " GGGG  HHHH  IIII ",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify_header: :right` is given" do
        it "must right justify the header cells" do
          expect {
            subject.print_table(table, header: header, justify_header: :right)
          }.to output(
            [
              "    A     B     C ",
              "",
              " AAAA  BBBB  CCCC ",
              " DDDD  EEEE  FFFF ",
              " GGGG  HHHH  IIII ",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify_header: :center` is given" do
        it "must center justify the header cells" do
          expect {
            subject.print_table(table, header: header, justify_header: :center)
          }.to output(
            [
              "  A     B     C   ",
              "",
              " AAAA  BBBB  CCCC ",
              " DDDD  EEEE  FFFF ",
              " GGGG  HHHH  IIII ",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :left` is given" do
        it "must left justify each cell" do
          expect {
            subject.print_table(unjustified_table, header:  header,
                                                   justify: :left)
          }.to output(
            [
              "  A     B     C   ",
              "",
              " AAAA  BBBB  CCCC ",
              " DD    EE    FF   ",
              " G     H     I    ",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :right` is given" do
        it "must right justify each cell" do
          expect {
            subject.print_table(unjustified_table, header:  header,
                                                   justify: :right)
          }.to output(
            [
              "  A     B     C   ",
              "",
              " AAAA  BBBB  CCCC ",
              "   DD    EE    FF ",
              "    G     H     I ",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :center` is given" do
        it "must center justify each cell" do
          expect {
            subject.print_table(unjustified_table, header:  header,
                                                   justify: :center)
          }.to output(
            [
              "  A     B     C   ",
              "",
              " AAAA  BBBB  CCCC ",
              "  DD    EE    FF  ",
              "  G     H     I   ",
              ''
            ].join($/)
          ).to_stdout
        end
      end
    end

    context "when given `border: :ascii`" do
      it "must print the table with an ASCII border" do
        expect {
          subject.print_table(table, border: :ascii)
        }.to output(
          [
            "+------+------+------+",
            "| AAAA | BBBB | CCCC |",
            "| DDDD | EEEE | FFFF |",
            "| GGGG | HHHH | IIII |",
            "+------+------+------+",
            ''
          ].join($/)
        ).to_stdout
      end

      context "but when the table contains multi-line cells" do
        it "must print each line of each row" do
          expect {
            subject.print_table(multiline_table, border: :ascii)
          }.to output(
            [
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "| AA   |      |      |",
              "| DDDD | EEEE | FFFF |",
              "|      | EE   |      |",
              "| GGGG | HHHH | IIII |",
              "|      |      | II   |",
              "+------+------+------+",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "but when the table contains empty cells" do
        it "must replace the empty cells with spaces" do
          expect {
            subject.print_table(table_with_empty_cells, border: :ascii)
          }.to output(
            [
              "+------+------+------+",
              "|      | BBBB | CCCC |",
              "| DDDD |      | FFFF |",
              "| GGGG | HHHH |      |",
              "+------+------+------+",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "but when the table contains empty cells" do
        it "must pad the columns with empty cells" do
          expect {
            subject.print_table(table_with_diff_row_lengths, border: :ascii)
          }.to output(
            [
              "+------+------+------+",
              "| AAAA |      |      |",
              "| DDDD | EEEE |      |",
              "| GGGG | HHHH | IIII |",
              "+------+------+------+",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `separate_rows: true` is given" do
        it "must add separator lines between each row" do
          expect {
            subject.print_table(table, border: :ascii, separate_rows: true)
          }.to output(
            [
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "+------+------+------+",
              "| DDDD | EEEE | FFFF |",
              "+------+------+------+",
              "| GGGG | HHHH | IIII |",
              "+------+------+------+",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :left` is given" do
        it "must left justify each cell" do
          expect {
            subject.print_table(unjustified_table, border:  :ascii,
                                                   justify: :left)
          }.to output(
            [
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "| DD   | EE   | FF   |",
              "| G    | H    | I    |",
              "+------+------+------+",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :right` is given" do
        it "must right justify each cell" do
          expect {
            subject.print_table(unjustified_table, border:  :ascii,
                                                   justify: :right)
          }.to output(
            [
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "|   DD |   EE |   FF |",
              "|    G |    H |    I |",
              "+------+------+------+",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :center` is given" do
        it "must center justify each cell" do
          expect {
            subject.print_table(unjustified_table, border:  :ascii,
                                                   justify: :center)
          }.to output(
            [
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "|  DD  |  EE  |  FF  |",
              "|  G   |  H   |  I   |",
              "+------+------+------+",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `header: true` is given" do
        it "must print the center justified header row, then a separator line, then the table" do
          expect {
            subject.print_table(table, border: :ascii, header: header)
          }.to output(
            [
              "+------+------+------+",
              "|  A   |  B   |  C   |",
              "+------+------+------+",
              "| AAAA | BBBB | CCCC |",
              "| DDDD | EEEE | FFFF |",
              "| GGGG | HHHH | IIII |",
              "+------+------+------+",
              ''
            ].join($/)
          ).to_stdout
        end

        context "and when `separate_rows: true` is given" do
          it "must print the header and add separator lines between each row" do
            expect {
              subject.print_table(table, border: :ascii,
                                         header: header,
                                         separate_rows: true)
            }.to output(
              [
                "+------+------+------+",
                "|  A   |  B   |  C   |",
                "+------+------+------+",
                "| AAAA | BBBB | CCCC |",
                "+------+------+------+",
                "| DDDD | EEEE | FFFF |",
                "+------+------+------+",
                "| GGGG | HHHH | IIII |",
                "+------+------+------+",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when `justify_header: :left` is given" do
          it "must left justify the header cells" do
            expect {
              subject.print_table(table, border: :ascii,
                                         header: header,
                                         justify_header: :left)
            }.to output(
              [
                "+------+------+------+",
                "| A    | B    | C    |",
                "+------+------+------+",
                "| AAAA | BBBB | CCCC |",
                "| DDDD | EEEE | FFFF |",
                "| GGGG | HHHH | IIII |",
                "+------+------+------+",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when `justify_header: :right` is given" do
          it "must right justify the header cells" do
            expect {
              subject.print_table(table, border: :ascii,
                                         header: header,
                                         justify_header: :right)
            }.to output(
              [
                "+------+------+------+",
                "|    A |    B |    C |",
                "+------+------+------+",
                "| AAAA | BBBB | CCCC |",
                "| DDDD | EEEE | FFFF |",
                "| GGGG | HHHH | IIII |",
                "+------+------+------+",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when `justify_header: :center` is given" do
          it "must center justify the header cells" do
            expect {
              subject.print_table(table, border: :ascii,
                                         header: header,
                                         justify_header: :center)
            }.to output(
              [
                "+------+------+------+",
                "|  A   |  B   |  C   |",
                "+------+------+------+",
                "| AAAA | BBBB | CCCC |",
                "| DDDD | EEEE | FFFF |",
                "| GGGG | HHHH | IIII |",
                "+------+------+------+",
                ''
              ].join($/)
            ).to_stdout
          end
        end
      end
    end

    context "when given `border: :line`" do
      it "must print the table with an ANSI line border" do
        expect {
          subject.print_table(table, border: :line)
        }.to output(
          [
            "┌──────┬──────┬──────┐",
            "│ AAAA │ BBBB │ CCCC │",
            "│ DDDD │ EEEE │ FFFF │",
            "│ GGGG │ HHHH │ IIII │",
            "└──────┴──────┴──────┘",
            ''
          ].join($/)
        ).to_stdout
      end

      context "but when the table contains multi-line cells" do
        it "must print each line of each row" do
          expect {
            subject.print_table(multiline_table, border: :line)
          }.to output(
            [
              "┌──────┬──────┬──────┐",
              "│ AAAA │ BBBB │ CCCC │",
              "│ AA   │      │      │",
              "│ DDDD │ EEEE │ FFFF │",
              "│      │ EE   │      │",
              "│ GGGG │ HHHH │ IIII │",
              "│      │      │ II   │",
              "└──────┴──────┴──────┘",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "but when the table contains empty cells" do
        it "must replace the empty cells with spaces" do
          expect {
            subject.print_table(table_with_empty_cells, border: :line)
          }.to output(
            [
              "┌──────┬──────┬──────┐",
              "│      │ BBBB │ CCCC │",
              "│ DDDD │      │ FFFF │",
              "│ GGGG │ HHHH │      │",
              "└──────┴──────┴──────┘",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "but when the table contains empty cells" do
        it "must pad the columns with empty cells" do
          expect {
            subject.print_table(table_with_diff_row_lengths, border: :line)
          }.to output(
            [
              "┌──────┬──────┬──────┐",
              "│ AAAA │      │      │",
              "│ DDDD │ EEEE │      │",
              "│ GGGG │ HHHH │ IIII │",
              "└──────┴──────┴──────┘",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `separate_rows: true` is given" do
        it "must add separator lines between each row" do
          expect {
            subject.print_table(table, border: :line, separate_rows: true)
          }.to output(
            [
              "┌──────┬──────┬──────┐",
              "│ AAAA │ BBBB │ CCCC │",
              "├──────┼──────┼──────┤",
              "│ DDDD │ EEEE │ FFFF │",
              "├──────┼──────┼──────┤",
              "│ GGGG │ HHHH │ IIII │",
              "└──────┴──────┴──────┘",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :left` is given" do
        it "must left justify each cell" do
          expect {
            subject.print_table(unjustified_table, border:  :line,
                                                   justify: :left)
          }.to output(
            [
              "┌──────┬──────┬──────┐",
              "│ AAAA │ BBBB │ CCCC │",
              "│ DD   │ EE   │ FF   │",
              "│ G    │ H    │ I    │",
              "└──────┴──────┴──────┘",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :right` is given" do
        it "must right justify each cell" do
          expect {
            subject.print_table(unjustified_table, border:  :line,
                                                   justify: :right)
          }.to output(
            [
              "┌──────┬──────┬──────┐",
              "│ AAAA │ BBBB │ CCCC │",
              "│   DD │   EE │   FF │",
              "│    G │    H │    I │",
              "└──────┴──────┴──────┘",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :center` is given" do
        it "must center justify each cell" do
          expect {
            subject.print_table(unjustified_table, border:  :line,
                                                   justify: :center)
          }.to output(
            [
              "┌──────┬──────┬──────┐",
              "│ AAAA │ BBBB │ CCCC │",
              "│  DD  │  EE  │  FF  │",
              "│  G   │  H   │  I   │",
              "└──────┴──────┴──────┘",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `header: true` is given" do
        it "must print the center justified header row, then a separator line, then the table" do
          expect {
            subject.print_table(table, border: :line, header: header)
          }.to output(
            [
              "┌──────┬──────┬──────┐",
              "│  A   │  B   │  C   │",
              "├──────┼──────┼──────┤",
              "│ AAAA │ BBBB │ CCCC │",
              "│ DDDD │ EEEE │ FFFF │",
              "│ GGGG │ HHHH │ IIII │",
              "└──────┴──────┴──────┘",
              ''
            ].join($/)
          ).to_stdout
        end

        context "and when `separate_rows: true` is given" do
          it "must print the header and add separator lines between each row" do
            expect {
              subject.print_table(table, border: :line,
                                         header: header,
                                         separate_rows: true)
            }.to output(
              [
                "┌──────┬──────┬──────┐",
                "│  A   │  B   │  C   │",
                "├──────┼──────┼──────┤",
                "│ AAAA │ BBBB │ CCCC │",
                "├──────┼──────┼──────┤",
                "│ DDDD │ EEEE │ FFFF │",
                "├──────┼──────┼──────┤",
                "│ GGGG │ HHHH │ IIII │",
                "└──────┴──────┴──────┘",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when `justify_header: :left` is given" do
          it "must left justify the header cells" do
            expect {
              subject.print_table(table, border: :line,
                                         header: header,
                                         justify_header: :left)
            }.to output(
              [
                "┌──────┬──────┬──────┐",
                "│ A    │ B    │ C    │",
                "├──────┼──────┼──────┤",
                "│ AAAA │ BBBB │ CCCC │",
                "│ DDDD │ EEEE │ FFFF │",
                "│ GGGG │ HHHH │ IIII │",
                "└──────┴──────┴──────┘",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when `justify_header: :right` is given" do
          it "must right justify the header cells" do
            expect {
              subject.print_table(table, border: :line,
                                         header: header,
                                         justify_header: :right)
            }.to output(
              [
                "┌──────┬──────┬──────┐",
                "│    A │    B │    C │",
                "├──────┼──────┼──────┤",
                "│ AAAA │ BBBB │ CCCC │",
                "│ DDDD │ EEEE │ FFFF │",
                "│ GGGG │ HHHH │ IIII │",
                "└──────┴──────┴──────┘",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when `justify_header: :center` is given" do
          it "must center justify the header cells" do
            expect {
              subject.print_table(table, border: :line,
                                         header: header,
                                         justify_header: :center)
            }.to output(
              [
                "┌──────┬──────┬──────┐",
                "│  A   │  B   │  C   │",
                "├──────┼──────┼──────┤",
                "│ AAAA │ BBBB │ CCCC │",
                "│ DDDD │ EEEE │ FFFF │",
                "│ GGGG │ HHHH │ IIII │",
                "└──────┴──────┴──────┘",
                ''
              ].join($/)
            ).to_stdout
          end
        end
      end
    end

    context "when given `border: :double_line`" do
      it "must print the table with an ANSI double-line border" do
        expect {
          subject.print_table(table, border: :double_line)
        }.to output(
          [
            "╔══════╦══════╦══════╗",
            "║ AAAA ║ BBBB ║ CCCC ║",
            "║ DDDD ║ EEEE ║ FFFF ║",
            "║ GGGG ║ HHHH ║ IIII ║",
            "╚══════╩══════╩══════╝",
            ''
          ].join($/)
        ).to_stdout
      end

      context "but when the table contains multi-line cells" do
        it "must print each line of each row" do
          expect {
            subject.print_table(multiline_table, border: :double_line)
          }.to output(
            [
              "╔══════╦══════╦══════╗",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "║ AA   ║      ║      ║",
              "║ DDDD ║ EEEE ║ FFFF ║",
              "║      ║ EE   ║      ║",
              "║ GGGG ║ HHHH ║ IIII ║",
              "║      ║      ║ II   ║",
              "╚══════╩══════╩══════╝",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "but when the table contains empty cells" do
        it "must replace the empty cells with spaces" do
          expect {
            subject.print_table(table_with_empty_cells, border: :double_line)
          }.to output(
            [
              "╔══════╦══════╦══════╗",
              "║      ║ BBBB ║ CCCC ║",
              "║ DDDD ║      ║ FFFF ║",
              "║ GGGG ║ HHHH ║      ║",
              "╚══════╩══════╩══════╝",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "but when the table contains empty cells" do
        it "must pad the columns with empty cells" do
          expect {
            subject.print_table(table_with_diff_row_lengths, border: :double_line)
          }.to output(
            [
              "╔══════╦══════╦══════╗",
              "║ AAAA ║      ║      ║",
              "║ DDDD ║ EEEE ║      ║",
              "║ GGGG ║ HHHH ║ IIII ║",
              "╚══════╩══════╩══════╝",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `separate_rows: true` is given" do
        it "must add separator lines between each row" do
          expect {
            subject.print_table(table, border: :double_line, separate_rows: true)
          }.to output(
            [
              "╔══════╦══════╦══════╗",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "╠══════╬══════╬══════╣",
              "║ DDDD ║ EEEE ║ FFFF ║",
              "╠══════╬══════╬══════╣",
              "║ GGGG ║ HHHH ║ IIII ║",
              "╚══════╩══════╩══════╝",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :left` is given" do
        it "must left justify each cell" do
          expect {
            subject.print_table(unjustified_table, border:  :double_line,
                                                   justify: :left)
          }.to output(
            [
              "╔══════╦══════╦══════╗",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "║ DD   ║ EE   ║ FF   ║",
              "║ G    ║ H    ║ I    ║",
              "╚══════╩══════╩══════╝",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :right` is given" do
        it "must right justify each cell" do
          expect {
            subject.print_table(unjustified_table, border:  :double_line,
                                                   justify: :right)
          }.to output(
            [
              "╔══════╦══════╦══════╗",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "║   DD ║   EE ║   FF ║",
              "║    G ║    H ║    I ║",
              "╚══════╩══════╩══════╝",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `justify: :center` is given" do
        it "must center justify each cell" do
          expect {
            subject.print_table(unjustified_table, border:  :double_line,
                                                   justify: :center)
          }.to output(
            [
              "╔══════╦══════╦══════╗",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "║  DD  ║  EE  ║  FF  ║",
              "║  G   ║  H   ║  I   ║",
              "╚══════╩══════╩══════╝",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when `header: true` is given" do
        it "must print the center justified header row, then a separator line, then the table" do
          expect {
            subject.print_table(table, border: :double_line, header: header)
          }.to output(
            [
              "╔══════╦══════╦══════╗",
              "║  A   ║  B   ║  C   ║",
              "╠══════╬══════╬══════╣",
              "║ AAAA ║ BBBB ║ CCCC ║",
              "║ DDDD ║ EEEE ║ FFFF ║",
              "║ GGGG ║ HHHH ║ IIII ║",
              "╚══════╩══════╩══════╝",
              ''
            ].join($/)
          ).to_stdout
        end

        context "and when `separate_rows: true` is given" do
          it "must print the header and add separator line between each row" do
            expect {
              subject.print_table(table, border: :double_line,
                                         header: header,
                                         separate_rows: true)
            }.to output(
              [
                "╔══════╦══════╦══════╗",
                "║  A   ║  B   ║  C   ║",
                "╠══════╬══════╬══════╣",
                "║ AAAA ║ BBBB ║ CCCC ║",
                "╠══════╬══════╬══════╣",
                "║ DDDD ║ EEEE ║ FFFF ║",
                "╠══════╬══════╬══════╣",
                "║ GGGG ║ HHHH ║ IIII ║",
                "╚══════╩══════╩══════╝",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when `justify_header: :left` is given" do
          it "must left justify the header cells" do
            expect {
              subject.print_table(table, border: :double_line,
                                         header: header,
                                         justify_header: :left)
            }.to output(
              [
                "╔══════╦══════╦══════╗",
                "║ A    ║ B    ║ C    ║",
                "╠══════╬══════╬══════╣",
                "║ AAAA ║ BBBB ║ CCCC ║",
                "║ DDDD ║ EEEE ║ FFFF ║",
                "║ GGGG ║ HHHH ║ IIII ║",
                "╚══════╩══════╩══════╝",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when `justify_header: :right` is given" do
          it "must right justify the header cells" do
            expect {
              subject.print_table(table, border: :double_line,
                                         header: header,
                                         justify_header: :right)
            }.to output(
              [
                "╔══════╦══════╦══════╗",
                "║    A ║    B ║    C ║",
                "╠══════╬══════╬══════╣",
                "║ AAAA ║ BBBB ║ CCCC ║",
                "║ DDDD ║ EEEE ║ FFFF ║",
                "║ GGGG ║ HHHH ║ IIII ║",
                "╚══════╩══════╩══════╝",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when `justify_header: :center` is given" do
          it "must center justify the header cells" do
            expect {
              subject.print_table(table, border: :double_line,
                                         header: header,
                                         justify_header: :center)
            }.to output(
              [
                "╔══════╦══════╦══════╗",
                "║  A   ║  B   ║  C   ║",
                "╠══════╬══════╬══════╣",
                "║ AAAA ║ BBBB ║ CCCC ║",
                "║ DDDD ║ EEEE ║ FFFF ║",
                "║ GGGG ║ HHHH ║ IIII ║",
                "╚══════╩══════╩══════╝",
                ''
              ].join($/)
            ).to_stdout
          end
        end
      end
    end
  end
end
