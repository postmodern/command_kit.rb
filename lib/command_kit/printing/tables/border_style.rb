module CommandKit
  module Printing
    module Tables
      #
      # Represents the table's border style.
      #
      # @api private
      #
      class BorderStyle

        # The top-left-corner border character.
        #
        # @return [String]
        attr_reader :top_left_corner

        # The top-border character.
        #
        # @return [String]
        attr_reader :top_border

        # The top-joined-border character.
        #
        # @return [String]
        attr_reader :top_joined_border

        # The top-right-corner border character.
        #
        # @return [String]
        attr_reader :top_right_corner

        # The left-hand-side border character.
        #
        # @return [String]
        attr_reader :left_border

        # The left-hand-side-joined-border character.
        #
        # @return [String]
        attr_reader :left_joined_border

        # The horizontal-separator character.
        #
        # @return [String]
        attr_reader :horizontal_separator

        # The vertical-separator character.
        #
        # @return [String]
        attr_reader :vertical_separator

        # The inner-joined border character.
        #
        # @return [String]
        attr_reader :inner_joined_border

        # The right-hand-side border character.
        #
        # @return [String]
        attr_reader :right_border

        # The right-hand-side joined border character.
        #
        # @return [String]
        attr_reader :right_joined_border

        # The bottom border character.
        #
        # @return [String]
        attr_reader :bottom_border

        # The bottom-left-corner border character.
        #
        # @return [String]
        attr_reader :bottom_left_corner

        # The bottom-joined border character.
        #
        # @return [String]
        attr_reader :bottom_joined_border

        # The bottom-right-corner border character.
        #
        # @return [String]
        attr_reader :bottom_right_corner

        #
        # Initializes the border style.
        #
        # @param [String] top_left_corner
        #   The top-left-corner border character.
        #
        # @param [String] top_border
        # The top-border character.
        #
        # @param [String] top_joined_border
        #   The top-joined-border character.
        #
        # @param [String] top_right_corner
        #   The top-right-corner border character.
        #
        # @param [String] left_border
        #   The left-hand-side border character.
        #
        # @param [String] left_joined_border
        #   The left-hand-side-joined-border character.
        #
        # @param [String] horizontal_separator
        #   The horizontal-separator character.
        #
        # @param [String] vertical_separator
        #   The vertical-separator character.
        #
        # @param [String] inner_joined_border
        #   The inner-joined border character.
        #
        # @param [String] right_border
        #   The right-hand-side border character.
        #
        # @param [String] right_joined_border
        #   The right-hand-side joined border character.
        #
        # @param [String] bottom_border
        #   The bottom border character.
        #
        # @param [String] bottom_left_corner
        #   The bottom-left-corner border character.
        #
        # @param [String] bottom_joined_border
        #   The bottom-joined border character.
        #
        # @param [String] bottom_right_corner
        #   The bottom-right-corner border character.
        #
        def initialize(top_left_corner:      ' ',
                       top_border:           ' ',
                       top_joined_border:    ' ',
                       top_right_corner:     ' ',
                       left_border:          ' ',
                       left_joined_border:   ' ',
                       horizontal_separator: ' ',
                       vertical_separator:   ' ',
                       inner_joined_border:  ' ',
                       right_border:         ' ',
                       right_joined_border:  ' ',
                       bottom_border:        ' ',
                       bottom_left_corner:   ' ',
                       bottom_joined_border: ' ',
                       bottom_right_corner:  ' ')
          @top_left_corner      = top_left_corner
          @top_border           = top_border
          @top_joined_border    = top_joined_border
          @top_right_corner     = top_right_corner
          @left_border          = left_border
          @left_joined_border   = left_joined_border
          @horizontal_separator = horizontal_separator
          @vertical_separator   = vertical_separator
          @inner_joined_border  = inner_joined_border
          @right_border         = right_border
          @right_joined_border  = right_joined_border
          @bottom_border        = bottom_border
          @bottom_left_corner   = bottom_left_corner
          @bottom_joined_border = bottom_joined_border
          @bottom_right_corner  = bottom_right_corner
        end

      end
    end
  end
end
