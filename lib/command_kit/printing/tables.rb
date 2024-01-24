# frozen_string_literal: true

require_relative 'indent'
require_relative 'tables/table_builder'
require_relative 'tables/style'
require_relative 'tables/table_formatter'

module CommandKit
  module Printing
    #
    # Methods for printing tables.
    #
    # ## Examples
    #
    #     include CommandKit::Printing::Tables
    #
    #     def run
    #       header = ['A', 'B', 'C']
    #       table = [
    #         ['AAAA', 'BBBB', 'CCCC'],
    #         ['AAAA', 'BBBB', 'CCCC'],
    #         ['AAAA', 'BBBB', 'CCCC']
    #       ]
    #
    #       print_table table
    #       # AAAA  BBBB  CCCC 
    #       # AAAA  BBBB  CCCC 
    #       # AAAA  BBBB  CCCC 
    #
    #       print_table table, header: header
    #       #  A     B     C   
    #       #
    #       # AAAA  BBBB  CCCC 
    #       # AAAA  BBBB  CCCC 
    #       # AAAA  BBBB  CCCC 
    #
    #       print_table table, header: header,
    #                          border: :ascii
    #       # +------+------+------+
    #       # |  A   |  B   |  C   |
    #       # +------+------+------+
    #       # | AAAA | BBBB | CCCC |
    #       # | AAAA | BBBB | CCCC |
    #       # | AAAA | BBBB | CCCC |
    #       # +------+------+------+
    #
    #       print_table table, header: header,
    #                          border: :ascii,
    #                          separate_rows: true
    #       # +------+------+------+
    #       # |  A   |  B   |  C   |
    #       # +------+------+------+
    #       # | AAAA | BBBB | CCCC |
    #       # +------+------+------+
    #       # | AAAA | BBBB | CCCC |
    #       # +------+------+------+
    #       # | AAAA | BBBB | CCCC |
    #       # +------+------+------+
    #
    #       print_table table, header: header,
    #                          border: :line
    #       # ┌──────┬──────┬──────┐
    #       # │  A   │  B   │  C   │
    #       # ├──────┼──────┼──────┤
    #       # │ AAAA │ BBBB │ CCCC │
    #       # │ AAAA │ BBBB │ CCCC │
    #       # │ AAAA │ BBBB │ CCCC │
    #       # └──────┴──────┴──────┘
    #
    #       print_table table, header: header,
    #                          border: :double_line
    #       # ╔══════╦══════╦══════╗
    #       # ║  A   ║  B   ║  C   ║
    #       # ╠══════╬══════╬══════╣
    #       # ║ AAAA ║ BBBB ║ CCCC ║
    #       # ║ AAAA ║ BBBB ║ CCCC ║
    #       # ║ AAAA ║ BBBB ║ CCCC ║
    #       # ╚══════╩══════╩══════╝
    #
    #       uneven_table = [
    #         ['AAAAAA', 'B',       'CCCCCCC'],
    #         ['AAA',    'BBBB',    'CCC'    ],
    #         ['A',      'BBBBBBB', 'C'      ]
    #       ]
    #
    #       print_table uneven_table, header: header,
    #                                 justify: :left,
    #                                 justify_header: :left,
    #                                 border: :line
    #       # ┌────────┬─────────┬─────────┐
    #       # │ A      │ B       │ C       │
    #       # ├────────┼─────────┼─────────┤
    #       # │ AAAAAA │ B       │ CCCCCCC │
    #       # │ AAA    │ BBBB    │ CCC     │
    #       # │ A      │ BBBBBBB │ C       │
    #       # └────────┴─────────┴─────────┘
    #
    #       print_table uneven_table, header: header,
    #                                 justify: :right,
    #                                 justify_header: :right,
    #                                 border: :line
    #       # ┌────────┬─────────┬─────────┐
    #       # │      A │       B │       C │
    #       # ├────────┼─────────┼─────────┤
    #       # │ AAAAAA │       B │ CCCCCCC │
    #       # │    AAA │    BBBB │     CCC │
    #       # │      A │ BBBBBBB │       C │
    #       # └────────┴─────────┴─────────┘
    #
    #       print_table uneven_table, header: header,
    #                                 justify: :center,
    #                                 justify_header: :center,
    #                                 border: :line
    #       # ┌────────┬─────────┬─────────┐
    #       # │   A    │    B    │    C    │
    #       # ├────────┼─────────┼─────────┤
    #       # │ AAAAAA │    B    │ CCCCCCC │
    #       # │  AAA   │  BBBB   │   CCC   │
    #       # │   A    │ BBBBBBB │    C    │
    #       # └────────┴─────────┴─────────┘
    #
    #       table_with_empty_cells = [
    #         ['AAAA', 'BBBB', 'CCCC'],
    #         ['AAAA', nil,    'CCCC'],
    #         ['AAAA', 'BBBB']
    #       ]
    #
    #       print_table table_with_empty_cells, header:  header,
    #                                           justify: :left,
    #                                           border:  :line
    #       # ┌──────┬──────┬──────┐
    #       # │  A   │  B   │  C   │
    #       # ├──────┼──────┼──────┤
    #       # │ AAAA │ BBBB │ CCCC │
    #       # │ AAAA │      │ CCCC │
    #       # │ AAAA │ BBBB │      │
    #       # └──────┴──────┴──────┘
    #
    #       multi_line_table = [
    #         ['AAAA',        'BBBB',    "CCCC\nCC"],
    #         ['AAAA',        "BBBB\nB", 'CCCC'],
    #         ["AAAA\nAA\nA", "BBBB",    "CCCC"]
    #       ]
    #
    #       print_table multi_line_table, header:  header,
    #                                     justify: :left,
    #                                     border:  :line
    #       # ┌──────┬──────┬──────┐
    #       # │  A   │  B   │  C   │
    #       # ├──────┼──────┼──────┤
    #       # │ AAAA │ BBBB │ CCCC │
    #       # │      │      │ CC   │
    #       # │ AAAA │ BBBB │ CCCC │
    #       # │      │ B    │      │
    #       # │ AAAA │ BBBB │ CCCC │
    #       # │ AA   │      │      │
    #       # │ A    │      │      │
    #       # └──────┴──────┴──────┘
    #     end
    #
    # @since 0.4.0
    #
    module Tables
      include Indent

      #
      # Prints a table of rows.
      #
      # @param [Array<Array>] rows
      #   The table rows.
      #
      # @param [Array, nil] header
      #   The optional header row.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @option kwargs [:line, :double_line, nil, Hash{Symbol => String}, :ascii] :border
      #   The border style or a custom Hash of border characters.
      #
      # @option [Integer] :padding (1)
      #   The number of characters to pad table cell values with.
      #
      # @option [:left, :right, :center] :justify (:left)
      #   Specifies how to justify the table cell values.
      #
      # @option [:left, :right, :center] :justify_header (:center)
      #   Specifies how to justify the table header cell values.
      #
      # @option [Boolean] :separate_rows (false)
      #   Specifies whether to add separator rows in between the rows.
      #
      # @api public
      #
      def print_table(rows, header: nil, **kwargs)
        table     = TableBuilder.new(rows, header: header)
        style     = Style.new(**kwargs)
        formatter = TableFormatter.new(table,style)

        formatter.format do |line|
          puts line
        end

        return nil
      end
    end
  end
end
