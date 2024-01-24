# frozen_string_literal: true
require_relative 'cell_builder'

module CommandKit
  module Printing
    module Tables
      #
      # Builds a table row and calculates it's dimensions.
      #
      # @api private
      #
      class RowBuilder

        include Enumerable

        # The cells within the row.
        #
        # @return [Array<CellBuilder>]
        attr_reader :cells

        # The height (in lines) for the row.
        #
        # @return [Integer]
        attr_reader :height

        # The width (in characters) for the row.
        #
        # @return [Integer]
        attr_reader :width

        # The number of columns in the row.
        #
        # @return [Integer]
        attr_reader :columns

        #
        # Initializes the row.
        #
        # @param [Array, nil] cells
        #   The cells for the row.
        #
        def initialize(cells=nil)
          @cells = []

          @height = 0
          @width  = 0

          @columns = 0

          if cells
            cells.each { |value| self << value }
          end
        end

        # An empty cell.
        EMPTY_CELL = CellBuilder.new

        #
        # Appends a value to the row.
        #
        # @param [#to_s] value
        #   The cell value to add to the row.
        #
        # @return [self]
        #
        def <<(value)
          new_cell = if value then CellBuilder.new(value)
                     else          EMPTY_CELL
                     end

          @height   = new_cell.height if new_cell.height > @height
          @width   += new_cell.width
          @columns += 1

          @cells << new_cell
          return self
        end

        #
        # Fetches a cell from the row.
        #
        # @param [Integer] column_index
        #   The column index.
        #
        # @return [CellBuilder]
        #   The cell at the given column index or an empty cell if the row
        #   does not have a cell at the given column index.
        #
        def [](column_index)
          @cells.fetch(column_index,EMPTY_CELL)
        end

        #
        # Enumerates over each cell in the row.
        #
        # @yield [cell]
        #   The given block will be passed each cell within the row.
        #
        # @yieldparam [CellBuilder] cell
        #   A cell within the row.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator will be returned.
        #
        def each(&block)
          @cells.each(&block)
        end

      end
    end
  end
end
