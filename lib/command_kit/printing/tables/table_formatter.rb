# frozen_string_literal: true

module CommandKit
  module Printing
    module Tables
      #
      # @api private
      #
      class TableFormatter

        #
        # Initialies the table formatter.
        #
        # @param [TableBuilder] table
        #   The table data to print.
        #
        # @param [Style] style
        #   The table's style configuration.
        #
        def initialize(table,style)
          @table = table
          @style = style

          @padding = ' ' * @style.padding
          @extra_padding = @style.padding * 2

          @last_column = @table.max_columns - 1
          @last_row    = @table.max_rows - 1
        end

        #
        # Formats the table.
        #
        # @yield [line]
        #   The given block will be passed each formatted line of the table.
        #
        # @yieldparam [String]
        #   A formatted line of the table.
        #
        def format(&block)
          yield format_top_border if @style.border

          separator_row = if @table.header? || @style.separate_rows?
                            format_separator_row
                          end

          @table.max_rows.times do |row_index|
            row = @table[row_index]

            if @table.header? && row_index == 0
              format_header_row(row,&block)

              yield separator_row
            else
              format_row(row,&block)

              if @style.separate_rows? && row_index < @last_row
                yield separator_row
              end
            end
          end

          yield format_bottom_border if @style.border
        end

        private

        #
        # Builds a horizontal border row.
        #
        # @param [String] left_border
        #   The left-hand side/corner border character.
        #
        # @param [String] column_border
        #   The top/bottom/horizontal column border character.
        #
        # @param [String] joined_border
        #   A joined border character.
        #
        # @param [String] right_border
        #   The right-hand side/corner border character.
        #
        # @return [String]
        #   The formatted border row.
        #
        def format_border_row(left_border: ,
                              column_border: ,
                              joined_border: ,
                              right_border: )
          line = String.new
          line << left_border

          @table.max_columns.times do |column_index|
            column_width = @table.column_widths[column_index] + @extra_padding

            line << column_border * column_width

            line << if column_index < @last_column
                      joined_border
                    else
                      right_border
                    end
          end

          return line
        end

        #
        # Builds the top border row.
        #
        # @return [String]
        #   The formatted top border row.
        #
        def format_top_border
          format_border_row(left_border:   @style.border.top_left_corner,
                            column_border: @style.border.top_border,
                            joined_border: @style.border.top_joined_border,
                            right_border:  @style.border.top_right_corner)
        end

        #
        # Builds the separator row.
        #
        # @return [String]
        #   The formatted separator row.
        #
        def format_separator_row
          if @style.border
            format_border_row(left_border:   @style.border.left_joined_border,
                              column_border: @style.border.horizontal_separator,
                              joined_border: @style.border.inner_joined_border,
                              right_border:  @style.border.right_joined_border)
          else
            ''
          end
        end

        #
        # Builds the top border row.
        #
        # @return [String]
        #   The formatted bottom border row.
        #
        def format_bottom_border
          format_border_row(left_border:   @style.border.bottom_left_corner,
                            column_border: @style.border.bottom_border,
                            joined_border: @style.border.bottom_joined_border,
                            right_border:  @style.border.bottom_right_corner)
        end

        #
        # Formats a cell value.
        #
        # @param [String] value
        #   The value from the cell.
        #
        # @param [Integer] width
        #   The desired width of the cell.
        #
        # @param [:left, :right, :center] justify
        #   How to justify the cell's value.
        #
        # @return [String]
        #   The formatted cell.
        #
        def format_cell(value, width: , justify: @style.justify)
          justified_value = case justify
                            when :center then value.center(width)
                            when :left   then value.ljust(width)
                            when :right  then value.rjust(width)
                            else
                              raise(ArgumentError,"invalid justify value (#{justify.inspect}), must be :left, :right, or :center")
                            end

          return "#{@padding}#{justified_value}#{@padding}"
        end

        #
        # Formats a specific line within a row.
        #
        # @param [RowBuilder] row
        #   The table row to format.
        #
        # @param [Integer] line_index
        #   The line index within the row to specifically format.
        #
        # @param [:left, :right, :center] justify
        #   How to justify each cell within the row.
        #
        # @return [String]
        #   The formatted row line.
        #
        def format_row_line(row,line_index, justify: @style.justify)
          line = String.new
          line << @style.border.left_border if @style.border

          @table.max_columns.times do |column_index|
            column_width = @table.column_widths[column_index]
            cell_line    = row[column_index][line_index]

            line << format_cell(cell_line, width:   column_width,
                                           justify: justify)

            if (@style.border && (column_index < @last_column))
              line << @style.border.vertical_separator
            end
          end

          line << @style.border.right_border if @style.border
          return line
        end

        #
        # Formats a row.
        #
        # @param [RowBuilder] row
        #   The table row to format.
        #
        # @param [:left, :right, :center] justify
        #   How to justify each cell within the row.
        #
        # @yield [line]
        #   The given block will be passed each formatted line within the row.
        #
        # @yieldparam [String] line
        #   A formatted line of the row.
        #
        def format_row(row, justify: @style.justify)
          row.height.times do |line_index|
            yield format_row_line(row,line_index, justify: justify)
          end
        end

        #
        # Formats a header row.
        #
        # @param [RowBuilder] row
        #   The header row to format.
        #
        # @yield [line]
        #   The given block will be passed each formatted line within the header
        #   row.
        #
        # @yieldparam [String] line
        #   A formatted line of the header row.
        #
        def format_header_row(row,&block)
          format_row(row, justify: @style.justify_header, &block)
        end

      end
    end
  end
end
