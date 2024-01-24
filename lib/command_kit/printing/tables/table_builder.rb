require_relative 'row_builder'

module CommandKit
  module Printing
    module Tables
      #
      # Builds a table and calculates it's dimensions.
      #
      # @api private
      #
      class TableBuilder

        include Enumerable

        # The rows within the table.
        #
        # @return [Array<RowBuilder>]
        attr_reader :rows

        # Indicates whether the table has a header row.
        #
        # @return [Boolean]
        attr_reader :header

        # The height (in lines) of the table.
        #
        # @return [Integer]
        attr_reader :height

        # The width (in characters) of the table.
        #
        # @return [Integer]
        attr_reader :width

        # The maximum number of rows in the table.
        #
        # @return [Integer]
        attr_reader :max_rows

        # The maximum number of columns in the table.
        #
        # @return [Integer]
        attr_reader :max_columns

        # The widths of the columns in the table.
        #
        # @return [Array<Integer>]
        attr_reader :column_widths

        #
        # Initializes the table.
        #
        # @param [Array<Array>] rows
        #   The rows for the table.
        #
        # @param [Array] header
        #   The header row.
        #
        def initialize(rows=[], header: nil)
          @rows    = []
          @height  = 0
          @width   = 0
          @column_widths = []

          @max_rows    = 0
          @max_columns = 0

          @header = !header.nil?

          self << header if header
          rows.each { |row| self << row }
        end

        #
        # Determines whether the table has a header row.
        #
        # @return [Boolean]
        #   Indicates whether the first row of the table is a header row.
        #
        def header?
          @header
        end

        #
        # Appends a row to the table.
        #
        # @param [Array] row
        #   The row to append.
        #
        # @return [self]
        #
        def <<(row)
          new_row = RowBuilder.new(row)

          new_row.each_with_index do |cell,index|
            column_width = @column_widths[index] || 0

            if cell.width > column_width
              @column_widths[index] = cell.width
            end
          end

          @height += new_row.height
          @width   = new_row.width if new_row.width > @width

          @max_rows   += 1
          @max_columns = new_row.columns if new_row.columns > @max_columns

          @rows << new_row
          return self
        end

        #
        # Fetches a row from the table.
        #
        # @param [Integer] row_index
        #   The row index to fetch the row at.
        #
        # @return [RowBuilder, nil]
        #   The row or `nil` if no row exists at the given row index.
        #
        def [](row_index)
          @rows[row_index]
        end

        #
        # Enumerates over each row in the table.
        #
        # @yield [row]
        #   If a block is given, it will be passed each row within the table.
        #
        # @yieldparam [RowBuilder] row
        #   A row within the table.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator will be returned.
        #
        def each(&block)
          @rows.each(&block)
        end

      end
    end
  end
end
