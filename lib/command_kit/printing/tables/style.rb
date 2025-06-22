# frozen_string_literal: true

require_relative 'border_style'

module CommandKit
  module Printing
    module Tables
      #
      # Contains the table's style configuration.
      #
      # @api private
      #
      class Style

        # Built-in border styles.
        BORDER_STYLES = {
          ascii: BorderStyle.new(
            top_left_corner:      '+',
            top_border:           '-',
            top_joined_border:    '+',
            top_right_corner:     '+',
            left_border:          '|',
            left_joined_border:   '+',
            horizontal_separator: '-',
            vertical_separator:   '|',
            inner_joined_border:  '+',
            right_border:         '|',
            right_joined_border:  '+',
            bottom_border:        '-',
            bottom_left_corner:   '+',
            bottom_joined_border: '+',
            bottom_right_corner:  '+'
          ),

          line: BorderStyle.new(
            top_left_corner:      '┌',
            top_border:           '─',
            top_joined_border:    '┬',
            top_right_corner:     '┐',
            left_border:          '│',
            left_joined_border:   '├',
            horizontal_separator: '─',
            vertical_separator:   '│',
            inner_joined_border:  '┼',
            right_border:         '│',
            right_joined_border:  '┤',
            bottom_border:        '─',
            bottom_left_corner:   '└',
            bottom_joined_border: '┴',
            bottom_right_corner:  '┘'
          ),

          double_line: BorderStyle.new(
            top_left_corner:      '╔',
            top_border:           '═',
            top_joined_border:    '╦',
            top_right_corner:     '╗',
            left_border:          '║',
            left_joined_border:   '╠',
            horizontal_separator: '═',
            vertical_separator:   '║',
            inner_joined_border:  '╬',
            right_border:         '║',
            right_joined_border:  '╣',
            bottom_border:        '═',
            bottom_left_corner:   '╚',
            bottom_joined_border: '╩',
            bottom_right_corner:  '╝'
          )
        }

        # The border style.
        #
        # @return [BorderStyle]
        attr_reader :border

        # The padding to use for cells.
        #
        # @return [Integer]
        attr_reader :padding

        # The justification to use for cells.
        #
        # @return [:left, :right, :center]
        attr_reader :justify

        # The justification to use for header cells.
        #
        # @return [:left, :right, :center]
        attr_reader :justify_header

        # Specifies whether to separate rows with a border row.
        #
        # @return [Boolean]
        attr_reader :separate_rows

        #
        # Initializes the style.
        #
        # @param [:line, :double_line, nil, Hash{Symbol => String}, :ascii] border
        #   The border style or a custom Hash of border characters.
        #
        # @option border [String] :top_left_corner (' ')
        #   The top-left-corner border character.
        #
        # @option border [String] :top_border (' ')
        # The top-border character.
        #
        # @option border [String] :top_joined_border (' ')
        #   The top-joined-border character.
        #
        # @option border [String] :top_right_corner (' ')
        #   The top-right-corner border character.
        #
        # @option border [String] :left_border (' ')
        #   The left-hand-side border character.
        #
        # @option border [String] :left_joined_border (' ')
        #   The left-hand-side-joined-border character.
        #
        # @option border [String] :horizontal_separator (' ')
        #   The horizontal-separator character.
        #
        # @option border [String] :vertical_separator (' ')
        #   The vertical-separator character.
        #
        # @option border [String] :inner_joined_border (' ')
        #   The inner-joined border character.
        #
        # @option border [String] :right_border (' ')
        #   The right-hand-side border character.
        #
        # @option border [String] :right_joined_border (' ')
        #   The right-hand-side joined border character.
        #
        # @option border [String] :bottom_border (' ')
        #   The bottom border character.
        #
        # @option border [String] :bottom_left_corner (' ')
        #   The bottom-left-corner border character.
        #
        # @option border [String] :bottom_joined_border (' ')
        #   The bottom-joined border character.
        #
        # @option border [String] :bottom_right_corner (' ')
        #   The bottom-right-corner border character.
        #
        # @param [Integer] padding
        #   The number of characters to pad table cell values with.
        #
        # @param [:left, :right, :center] justify
        #   Specifies how to justify the table cell values.
        #
        # @param [:left, :right, :center] justify_header
        #   Specifies how to justify the table header cell values.
        #
        # @param [Boolean] separate_rows
        #   Specifies whether to add separator rows in between the rows.
        #
        def initialize(border: nil,
                       padding: 1,
                       justify:        :left,
                       justify_header: :center,
                       separate_rows:  false)
          @border = case border
                    when Hash
                      BorderStyle.new(**border)
                    when Symbol
                      BORDER_STYLES.fetch(border) do
                        raise(ArgumentError,"unknown border style (#{border.inspect}) must be either #{BORDER_STYLES.keys.map(&:inspect).join(', ')}")
                      end
                    when nil then nil
                    else
                      raise(ArgumentError,"invalid border value (#{border.inspect}) must be either #{BORDER_STYLES.keys.map(&:inspect).join(', ')}, Hash, or nil")
                    end

          @padding = padding

          @justify        = justify
          @justify_header = justify_header

          @separate_rows  = separate_rows
        end

        #
        # Determines if the rows should be separated.
        #
        # @return [Boolean]
        #   Specifies whether each row should be separated with a separator row.
        #
        def separate_rows? = @separate_rows

      end
    end
  end
end
