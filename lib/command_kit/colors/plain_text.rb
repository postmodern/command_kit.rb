# frozen_string_literal: true

module CommandKit
  module Colors
    #
    # Dummy module that does not apply any ANSI formatting to text, for when
    # stdout is redirected to a file or piped to another command.
    #
    module PlainText
      # @!macro dummy_constant
      #   Dummy constant for API compatibility with {ANSI}.

      # @!macro dummy_constant
      RESET = ''

      # @!macro dummy_constant
      CLEAR = ''

      # @!macro dummy_constant
      BOLD = ''

      # @!macro dummy_constant
      RESET_INTENSITY = ''

      # @!macro dummy_constant
      BLACK = ''

      # @!macro dummy_constant
      RED = ''

      # @!macro dummy_constant
      GREEN = ''

      # @!macro dummy_constant
      YELLOW = ''

      # @!macro dummy_constant
      BLUE = ''

      # @!macro dummy_constant
      MAGENTA = ''

      # @!macro dummy_constant
      CYAN = ''

      # @!macro dummy_constant
      WHITE = ''

      # @!macro dummy_constant
      # @since 0.3.0
      BRIGHT_BLACK = ''

      # @!macro dummy_constant
      # @since 0.3.0
      BRIGHT_RED = ''

      # @!macro dummy_constant
      # @since 0.3.0
      BRIGHT_GREEN = ''

      # @!macro dummy_constant
      # @since 0.3.0
      BRIGHT_YELLOW = ''

      # @!macro dummy_constant
      # @since 0.3.0
      BRIGHT_BLUE = ''

      # @!macro dummy_constant
      # @since 0.3.0
      BRIGHT_MAGENTA = ''

      # @!macro dummy_constant
      # @since 0.3.0
      BRIGHT_CYAN = ''

      # @!macro dummy_constant
      # @since 0.3.0
      BRIGHT_WHITE = ''

      # @!macro dummy_constant
      # @since 0.3.0
      RESET_FG = ''

      # @!macro dummy_constant
      # @see RESET_FG
      RESET_COLOR = ''

      # @!macro dummy_constant
      # @since 0.2.0
      ON_BLACK = ''

      # @!macro dummy_constant
      # @since 0.2.0
      ON_RED = ''

      # @!macro dummy_constant
      # @since 0.2.0
      ON_GREEN = ''

      # @!macro dummy_constant
      # @since 0.2.0
      ON_YELLOW = ''

      # @!macro dummy_constant
      # @since 0.2.0
      ON_BLUE = ''

      # @!macro dummy_constant
      # @since 0.2.0
      ON_MAGENTA = ''

      # @!macro dummy_constant
      # @since 0.2.0
      ON_CYAN = ''

      # @!macro dummy_constant
      # @since 0.2.0
      ON_WHITE = ''

      # @!macro dummy_constant
      # @since 0.3.0
      ON_BRIGHT_BLACK = ''

      # @!macro dummy_constant
      # @since 0.3.0
      ON_BRIGHT_RED = ''

      # @!macro dummy_constant
      # @since 0.3.0
      ON_BRIGHT_GREEN = ''

      # @!macro dummy_constant
      # @since 0.3.0
      ON_BRIGHT_YELLOW = ''

      # @!macro dummy_constant
      # @since 0.3.0
      ON_BRIGHT_BLUE = ''

      # @!macro dummy_constant
      # @since 0.3.0
      ON_BRIGHT_MAGENTA = ''

      # @!macro dummy_constant
      # @since 0.3.0
      ON_BRIGHT_CYAN = ''

      # @!macro dummy_constant
      # @since 0.3.0
      ON_BRIGHT_WHITE = ''

      # @!macro dummy_constant
      # @since 0.2.0
      RESET_BG = ''

      module_function

      #
      # Dummy method for API compatibility with {ANSI}.
      #
      # @return [String]
      #   An empty string.
      #
      def reset = ''

      #
      # Dummy method for API compatibility with {ANSI}.
      #
      # @return [String]
      #   An empty string.
      #
      def clear = ''

      #
      # @!macro dummy_method
      #   Dummy method for API compatibility with {ANSI}.
      #
      #   @param [String, nil] string
      #     The string that would normally be ANSI highlighted.
      #
      #   @return [String]
      #     The unchanged string or an empty string if no string was given.
      #
      #   @see ANSI.$0
      #   @api public
      #

      # @!macro dummy_method
      def bold(string=nil) = string || ''

      #
      # @group Foreground Color Methods
      #

      # @!macro dummy_method
      def black(string=nil) = string || ''

      # @!macro dummy_method
      def red(string=nil) = string || ''

      # @!macro dummy_method
      def green(string=nil) = string || ''

      # @!macro dummy_method
      def yellow(string=nil) = string || ''

      # @!macro dummy_method
      def blue(string=nil) = string || ''

      # @!macro dummy_method
      def magenta(string=nil) = string || ''

      # @!macro dummy_method
      def cyan(string=nil) = string || ''

      # @!macro dummy_method
      def white(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def bright_black(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def gray(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def bright_red(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def bright_green(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def bright_yellow(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def bright_blue(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def bright_magenta(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def bright_cyan(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def bright_white(string=nil) = string || ''

      #
      # @group Background Color Methods
      #

      # @!macro dummy_method
      # @since 0.2.0
      def on_black(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.2.0
      def on_red(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.2.0
      def on_green(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.2.0
      def on_yellow(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.2.0
      def on_blue(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.2.0
      def on_magenta(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.2.0
      def on_cyan(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.2.0
      def on_white(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def on_bright_black(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def on_gray(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def on_bright_red(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def on_bright_green(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def on_bright_yellow(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def on_bright_blue(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def on_bright_magenta(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def on_bright_cyan(string=nil) = string || ''

      # @!macro dummy_method
      # @since 0.3.0
      def on_bright_white(string=nil) = string || ''
    end
  end
end
