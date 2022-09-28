#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../../lib',__FILE__))
require 'command_kit/command'
require 'command_kit/printing/tables'

class TablesCmd < CommandKit::Command

  include CommandKit::Printing::Tables

  def run
    header = ['A', 'B', 'C']
    table = [
      ['AAAA', 'BBBB', 'CCCC'],
      ['AAAA', 'BBBB', 'CCCC'],
      ['AAAA', 'BBBB', 'CCCC']
    ]

    puts
    puts "Table:"
    puts
    print_table table

    puts
    puts "Table with header:"
    puts
    print_table table, header: header

    puts
    puts "ASCII border:"
    puts

    print_table table, header: header,
                       border: :ascii

    puts
    puts "Border + Separated rows:"
    puts

    print_table table, header: header,
                       border: :ascii,
                       separate_rows: true

    puts
    puts "Lined border:"
    puts

    print_table table, header: header,
                       border: :line

    puts
    puts "Double line border:"
    puts

    print_table table, header: header,
                       border: :double_line

    uneven_table = [
      ['AAAAAA', 'B',       'CCCCCCC'],
      ['AAA',    'BBBB',    'CCC'    ],
      ['A',      'BBBBBBB', 'C'      ]
    ]

    puts
    puts "Left-justified:"
    puts

    print_table uneven_table, header: header,
                              justify: :left,
                              justify_header: :left,
                              border: :line

    puts
    puts "Right-justified:"
    puts

    print_table uneven_table, header: header,
                              justify: :right,
                              justify_header: :right,
                              border: :line

    puts
    puts "Center-justified:"
    puts

    print_table uneven_table, header: header,
                              justify: :center,
                              justify_header: :center,
                              border: :line

    puts
    puts "Table with empty cells:"
    puts

    table_with_empty_cells = [
      ['AAAA', 'BBBB', 'CCCC'],
      ['AAAA', nil,    'CCCC'],
      ['AAAA', 'BBBB']
    ]

    print_table table_with_empty_cells, header:  header,
                                        justify: :left,
                                        border:  :line

    puts
    puts "Multi-line table:"
    puts

    multi_line_table = [
      ['AAAA',        'BBBB',    "CCCC\nCC"],
      ['AAAA',        "BBBB\nB", 'CCCC'],
      ["AAAA\nAA\nA", "BBBB",    "CCCC"]
    ]

    print_table multi_line_table, header:  header,
                                  justify: :left,
                                  border:  :line

    puts
    puts "Indent aware:"
    puts

    puts "* Item 1"
    indent do
      puts "* Item 2"
      puts

      indent do
        print_table table, header: header,
                           border: :line
      end
    end

    puts
  end

end

if __FILE__ == $0
  TablesCmd.start
end
