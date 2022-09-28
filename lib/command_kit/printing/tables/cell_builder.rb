# frozen_string_literal: true

module CommandKit
  module Printing
    module Tables
      #
      # Build's a cell and calculates it's dimensions.
      #
      # @api private
      #
      class CellBuilder

        # The lines within the cell.
        #
        # @return [Array<String>]
        attr_reader :lines

        # The height (in lines) of the cell.
        #
        # @return [Integer]
        attr_reader :height

        # The with (in characters) of the cell.
        #
        # @return [Integer]
        attr_reader :width

        #
        # Initializes the cell.
        #
        # @param [#to_s] value
        #   The value for the cell.
        #
        def initialize(value=nil)
          @lines  = []
          @height = 0
          @width  = 0

          if value
            value.to_s.each_line(chomp: true) do |line|
              self << line
            end
          end
        end

        #
        # Calculates the width of a string, sans any ASNI escape sequences.
        #
        # @param [String] string
        #   The string to calculate the width of.
        #
        # @return [Integer]
        #   The display width of the string.
        #
        def self.line_width(string)
          string.gsub(/\e\[\d+m/,'').length
        end

        #
        # Adds a line to the cell.
        #
        # @param [String] line
        #   A line to add to the cell.
        #
        # @return [self]
        #
        def <<(line)
          line_width = self.class.line_width(line)

          @height += 1
          @width   = line_width if line_width > @width

          @lines << line
          return self
        end

        #
        # Fetches a line from the cell.
        #
        # @param [Integer] line_index
        #   The line index to fetch.
        #
        # @return [String]
        #   The line at the line index or an empty String if the cell is empty.
        #
        def [](line_index)
          @lines.fetch(line_index,'')
        end

      end
    end
  end
end
