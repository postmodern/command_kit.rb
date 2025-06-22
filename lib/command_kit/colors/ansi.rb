# frozen_string_literal: true

module CommandKit
  module Colors
    #
    # Applies ANSI formatting to text.
    #
    module ANSI
      # ANSI reset code
      RESET = "\e[0m"

      # @see RESET
      CLEAR = RESET

      # ANSI code for bold text
      BOLD = "\e[1m"

      # ANSI code to disable boldness
      RESET_INTENSITY = "\e[22m"

      # ANSI color code for black
      BLACK = "\e[30m"

      # ANSI color code for red
      RED = "\e[31m"

      # ANSI color code for green
      GREEN = "\e[32m"

      # ANSI color code for yellow
      YELLOW = "\e[33m"

      # ANSI color code for blue
      BLUE = "\e[34m"

      # ANSI color code for magenta
      MAGENTA = "\e[35m"

      # ANSI color code for cyan
      CYAN = "\e[36m"

      # ANSI color code for white
      WHITE = "\e[37m"

      # ANSI color code for black
      #
      # @since 0.3.0
      BRIGHT_BLACK = "\e[90m"

      # ANSI color code for red
      #
      # @since 0.3.0
      BRIGHT_RED = "\e[91m"

      # ANSI color code for green
      #
      # @since 0.3.0
      BRIGHT_GREEN = "\e[92m"

      # ANSI color code for yellow
      #
      # @since 0.3.0
      BRIGHT_YELLOW = "\e[93m"

      # ANSI color code for blue
      #
      # @since 0.3.0
      BRIGHT_BLUE = "\e[94m"

      # ANSI color code for magenta
      #
      # @since 0.3.0
      BRIGHT_MAGENTA = "\e[95m"

      # ANSI color code for cyan
      #
      # @since 0.3.0
      BRIGHT_CYAN = "\e[96m"

      # ANSI color code for white
      #
      # @since 0.3.0
      BRIGHT_WHITE = "\e[97m"

      # ANSI color for the default foreground color
      #
      # @since 0.3.0
      RESET_FG = "\e[39m"

      # @see RESET_FG
      RESET_COLOR = RESET_FG

      # ANSI color code for background color black
      #
      # @since 0.2.0
      ON_BLACK = "\e[40m"

      # ANSI color code for background color red
      #
      # @since 0.2.0
      ON_RED = "\e[41m"

      # ANSI color code for background color green
      #
      # @since 0.2.0
      ON_GREEN = "\e[42m"

      # ANSI color code for background color yellow
      #
      # @since 0.2.0
      ON_YELLOW = "\e[43m"

      # ANSI color code for background color blue
      #
      # @since 0.2.0
      ON_BLUE = "\e[44m"

      # ANSI color code for background color magenta
      #
      # @since 0.2.0
      ON_MAGENTA = "\e[45m"

      # ANSI color code for background color cyan
      #
      # @since 0.2.0
      ON_CYAN = "\e[46m"

      # ANSI color code for background color white
      #
      # @since 0.2.0
      ON_WHITE = "\e[47m"

      # ANSI color code for background color bright black
      #
      # @since 0.3.0
      ON_BRIGHT_BLACK = "\e[100m"

      # ANSI color code for background color bright red
      #
      # @since 0.3.0
      ON_BRIGHT_RED = "\e[101m"

      # ANSI color code for background color bright green
      #
      # @since 0.3.0
      ON_BRIGHT_GREEN = "\e[102m"

      # ANSI color code for background color bright yellow
      #
      # @since 0.3.0
      ON_BRIGHT_YELLOW = "\e[103m"

      # ANSI color code for background color bright blue
      #
      # @since 0.3.0
      ON_BRIGHT_BLUE = "\e[104m"

      # ANSI color code for background color bright magenta
      #
      # @since 0.3.0
      ON_BRIGHT_MAGENTA = "\e[105m"

      # ANSI color code for background color bright cyan
      #
      # @since 0.3.0
      ON_BRIGHT_CYAN = "\e[106m"

      # ANSI color code for background color bright white
      #
      # @since 0.3.0
      ON_BRIGHT_WHITE = "\e[107m"

      # ANSI color for the default background color
      #
      # @since 0.2.0
      RESET_BG = "\e[49m"

      module_function

      #
      # @group Styling Methods
      #

      #
      # Resets text formatting.
      #
      # @return [RESET]
      #
      # @see RESET
      #
      # @api public
      #
      def reset = RESET

      #
      # @see reset
      #
      # @api public
      #
      def clear = reset

      #
      # Bolds the text.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BOLD]
      #   The bolded string or just {BOLD} if no arguments were given.
      #
      # @see BOLD
      #
      # @api public
      #
      def bold(string=nil)
        if string then "#{BOLD}#{string}#{RESET_INTENSITY}"
        else           BOLD
        end
      end

      #
      # @group Foreground Color Methods
      #

      #
      # Sets the text color to black.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BLACK]
      #   The colorized string or just {BLACK} if no arguments were given.
      #
      # @see BLACK
      #
      # @api public
      #
      def black(string=nil)
        if string then "#{BLACK}#{string}#{RESET_FG}"
        else           BLACK
        end
      end

      #
      # Sets the text color to red.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, RED]
      #   The colorized string or just {RED} if no arguments were given.
      #
      # @see RED
      #
      # @api public
      #
      def red(string=nil)
        if string then "#{RED}#{string}#{RESET_FG}"
        else           RED
        end
      end

      #
      # Sets the text color to green.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, GREEN]
      #   The colorized string or just {GREEN} if no arguments were given.
      #
      # @see GREEN
      #
      # @api public
      #
      def green(string=nil)
        if string then "#{GREEN}#{string}#{RESET_FG}"
        else           GREEN
        end
      end

      #
      # Sets the text color to yellow.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, YELLOW]
      #   The colorized string or just {YELLOW} if no arguments were given.
      #
      # @see YELLOW
      #
      # @api public
      #
      def yellow(string=nil)
        if string then "#{YELLOW}#{string}#{RESET_FG}"
        else           YELLOW
        end
      end

      #
      # Sets the text color to blue.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BLUE]
      #   The colorized string or just {BLUE} if no arguments were given.
      #
      # @see BLUE
      #
      # @api public
      #
      def blue(string=nil)
        if string then "#{BLUE}#{string}#{RESET_FG}"
        else           BLUE
        end
      end

      #
      # Sets the text color to magenta.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, MAGENTA]
      #   The colorized string or just {MAGENTA} if no arguments were given.
      #
      # @see MAGENTA
      #
      # @api public
      #
      def magenta(string=nil)
        if string then "#{MAGENTA}#{string}#{RESET_FG}"
        else           MAGENTA
        end
      end

      #
      # Sets the text color to cyan.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, CYAN]
      #   The colorized string or just {CYAN} if no arguments were given.
      #
      # @see CYAN
      #
      # @api public
      #
      def cyan(string=nil)
        if string then "#{CYAN}#{string}#{RESET_FG}"
        else           CYAN
        end
      end

      #
      # Sets the text color to white.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, WHITE]
      #   The colorized string or just {WHITE} if no arguments were given.
      #
      # @see WHITE
      #
      # @api public
      #
      def white(string=nil)
        if string then "#{WHITE}#{string}#{RESET_FG}"
        else           WHITE
        end
      end

      #
      # Sets the text color to bright black (gray).
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BRIGHT_BLACK]
      #   The colorized string or just {BRIGHT_BLACK} if no arguments were
      #   given.
      #
      # @see BRIGHT_BLACK
      #
      # @api public
      #
      # @since 0.3.0
      #
      def bright_black(string=nil)
        if string then "#{BRIGHT_BLACK}#{string}#{RESET_FG}"
        else           BRIGHT_BLACK
        end
      end

      #
      # Sets the text color to gray.
      #
      # @api public
      #
      # @see #bright_black
      #
      # @since 0.3.0
      #
      def gray(string=nil) = bright_black(string)

      #
      # Sets the text color to bright red.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BRIGHT_RED]
      #   The colorized string or just {BRIGHT_RED} if no arguments were given.
      #
      # @see BRIGHT_RED
      #
      # @api public
      #
      # @since 0.3.0
      #
      def bright_red(string=nil)
        if string then "#{BRIGHT_RED}#{string}#{RESET_FG}"
        else           BRIGHT_RED
        end
      end

      #
      # Sets the text color to bright green.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BRIGHT_GREEN]
      #   The colorized string or just {BRIGHT_GREEN} if no arguments were
      #   given.
      #
      # @see BRIGHT_GREEN
      #
      # @api public
      #
      # @since 0.3.0
      #
      def bright_green(string=nil)
        if string then "#{BRIGHT_GREEN}#{string}#{RESET_FG}"
        else           BRIGHT_GREEN
        end
      end

      #
      # Sets the text color to bright yellow.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BRIGHT_YELLOW]
      #   The colorized string or just {BRIGHT_YELLOW} if no arguments were
      #   given.
      #
      # @see BRIGHT_YELLOW
      #
      # @api public
      #
      # @since 0.3.0
      #
      def bright_yellow(string=nil)
        if string then "#{BRIGHT_YELLOW}#{string}#{RESET_FG}"
        else           BRIGHT_YELLOW
        end
      end

      #
      # Sets the text color to bright blue.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BRIGHT_BLUE]
      #   The colorized string or just {BRIGHT_BLUE} if no arguments were given.
      #
      # @see BRIGHT_BLUE
      #
      # @api public
      #
      # @since 0.3.0
      #
      def bright_blue(string=nil)
        if string then "#{BRIGHT_BLUE}#{string}#{RESET_FG}"
        else           BRIGHT_BLUE
        end
      end

      #
      # Sets the text color to bright magenta.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BRIGHT_MAGENTA]
      #   The colorized string or just {BRIGHT_MAGENTA} if no arguments were
      #   given.
      #
      # @see BRIGHT_MAGENTA
      #
      # @api public
      #
      # @since 0.3.0
      #
      def bright_magenta(string=nil)
        if string then "#{BRIGHT_MAGENTA}#{string}#{RESET_FG}"
        else           BRIGHT_MAGENTA
        end
      end

      #
      # Sets the text color to bright cyan.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BRIGHT_CYAN]
      #   The colorized string or just {BRIGHT_CYAN} if no arguments were given.
      #
      # @see BRIGHT_CYAN
      #
      # @api public
      #
      # @since 0.3.0
      #
      def bright_cyan(string=nil)
        if string then "#{BRIGHT_CYAN}#{string}#{RESET_FG}"
        else           BRIGHT_CYAN
        end
      end

      #
      # Sets the text color to bright white.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, BRIGHT_WHITE]
      #   The colorized string or just {BRIGHT_WHITE} if no arguments were
      #   given.
      #
      # @see BRIGHT_WHITE
      #
      # @api public
      #
      # @since 0.3.0
      #
      def bright_white(string=nil)
        if string then "#{BRIGHT_WHITE}#{string}#{RESET_FG}"
        else           BRIGHT_WHITE
        end
      end

      #
      # @group Background Color Methods
      #

      #
      # Sets the background color to black.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BLACK]
      #   The colorized string or just {ON_BLACK} if no arguments were given.
      #
      # @see ON_BLACK
      #
      # @api public
      #
      # @since 0.2.0
      #
      def on_black(string=nil)
        if string then "#{ON_BLACK}#{string}#{RESET_BG}"
        else           ON_BLACK
        end
      end

      #
      # Sets the background color to red.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_RED]
      #   The colorized string or just {ON_RED} if no arguments were given.
      #
      # @see ON_RED
      #
      # @api public
      #
      # @since 0.2.0
      #
      def on_red(string=nil)
        if string then "#{ON_RED}#{string}#{RESET_BG}"
        else           ON_RED
        end
      end

      #
      # Sets the background color to green.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_GREEN]
      #   The colorized string or just {ON_GREEN} if no arguments were given.
      #
      # @see ON_GREEN
      #
      # @api public
      #
      # @since 0.2.0
      #
      def on_green(string=nil)
        if string then "#{ON_GREEN}#{string}#{RESET_BG}"
        else           ON_GREEN
        end
      end

      #
      # Sets the background color to yellow.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_YELLOW]
      #   The colorized string or just {ON_YELLOW} if no arguments were given.
      #
      # @see ON_YELLOW
      #
      # @api public
      #
      # @since 0.2.0
      #
      def on_yellow(string=nil)
        if string then "#{ON_YELLOW}#{string}#{RESET_BG}"
        else           ON_YELLOW
        end
      end

      #
      # Sets the background color to blue.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BLUE]
      #   The colorized string or just {ON_BLUE} if no arguments were given.
      #
      # @see ON_BLUE
      #
      # @api public
      #
      # @since 0.2.0
      #
      def on_blue(string=nil)
        if string then "#{ON_BLUE}#{string}#{RESET_BG}"
        else           ON_BLUE
        end
      end

      #
      # Sets the background color to magenta.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_MAGENTA]
      #   The colorized string or just {ON_MAGENTA} if no arguments were given.
      #
      # @see ON_MAGENTA
      #
      # @api public
      #
      # @since 0.2.0
      #
      def on_magenta(string=nil)
        if string then "#{ON_MAGENTA}#{string}#{RESET_BG}"
        else           ON_MAGENTA
        end
      end

      #
      # Sets the background color to cyan.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_CYAN]
      #   The colorized string or just {ON_CYAN} if no arguments were given.
      #
      # @see ON_CYAN
      #
      # @api public
      #
      # @since 0.2.0
      #
      def on_cyan(string=nil)
        if string then "#{ON_CYAN}#{string}#{RESET_BG}"
        else           ON_CYAN
        end
      end

      #
      # Sets the background color to white.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_WHITE]
      #   The colorized string or just {ON_WHITE} if no arguments were given.
      #
      # @see ON_WHITE
      #
      # @api public
      #
      # @since 0.2.0
      #
      def on_white(string=nil)
        if string then "#{ON_WHITE}#{string}#{RESET_BG}"
        else           ON_WHITE
        end
      end

      #
      # Sets the background color to bright black.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BRIGHT_BLACK]
      #   The colorized string or just {ON_BRIGHT_BLACK} if no arguments were
      #   given.
      #
      # @see ON_BRIGHT_BLACK
      #
      # @api public
      #
      # @since 0.3.0
      #
      def on_bright_black(string=nil)
        if string then "#{ON_BRIGHT_BLACK}#{string}#{RESET_BG}"
        else           ON_BRIGHT_BLACK
        end
      end

      #
      # @see #on_bright_black
      #
      # @api public
      #
      # @since 0.3.0
      #
      def on_gray(string=nil) = on_bright_black(string)

      #
      # Sets the background color to bright red.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BRIGHT_RED]
      #   The colorized string or just {ON_BRIGHT_RED} if no arguments were
      #   given.
      #
      # @see ON_BRIGHT_RED
      #
      # @api public
      #
      # @since 0.3.0
      #
      def on_bright_red(string=nil)
        if string then "#{ON_BRIGHT_RED}#{string}#{RESET_BG}"
        else           ON_BRIGHT_RED
        end
      end

      #
      # Sets the background color to bright green.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BRIGHT_GREEN]
      #   The colorized string or just {ON_BRIGHT_GREEN} if no arguments were
      #   given.
      #
      # @see ON_BRIGHT_GREEN
      #
      # @api public
      #
      # @since 0.3.0
      #
      def on_bright_green(string=nil)
        if string then "#{ON_BRIGHT_GREEN}#{string}#{RESET_BG}"
        else           ON_BRIGHT_GREEN
        end
      end

      #
      # Sets the background color to bright yellow.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BRIGHT_YELLOW]
      #   The colorized string or just {ON_BRIGHT_YELLOW} if no arguments were
      #   given.
      #
      # @see ON_BRIGHT_YELLOW
      #
      # @api public
      #
      # @since 0.3.0
      #
      def on_bright_yellow(string=nil)
        if string then "#{ON_BRIGHT_YELLOW}#{string}#{RESET_BG}"
        else           ON_BRIGHT_YELLOW
        end
      end

      #
      # Sets the background color to bright blue.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BRIGHT_BLUE]
      #   The colorized string or just {ON_BRIGHT_BLUE} if no arguments were
      #   given.
      #
      # @see ON_BRIGHT_BLUE
      #
      # @api public
      #
      # @since 0.3.0
      #
      def on_bright_blue(string=nil)
        if string then "#{ON_BRIGHT_BLUE}#{string}#{RESET_BG}"
        else           ON_BRIGHT_BLUE
        end
      end

      #
      # Sets the background color to bright magenta.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BRIGHT_MAGENTA]
      #   The colorized string or just {ON_BRIGHT_MAGENTA} if no arguments were
      #   given.
      #
      # @see ON_BRIGHT_MAGENTA
      #
      # @api public
      #
      # @since 0.3.0
      #
      def on_bright_magenta(string=nil)
        if string then "#{ON_BRIGHT_MAGENTA}#{string}#{RESET_BG}"
        else           ON_BRIGHT_MAGENTA
        end
      end

      #
      # Sets the background color to bright cyan.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BRIGHT_CYAN]
      #   The colorized string or just {ON_BRIGHT_CYAN} if no arguments were
      #   given.
      #
      # @see ON_BRIGHT_CYAN
      #
      # @api public
      #
      # @since 0.3.0
      #
      def on_bright_cyan(string=nil)
        if string then "#{ON_BRIGHT_CYAN}#{string}#{RESET_BG}"
        else           ON_BRIGHT_CYAN
        end
      end

      #
      # Sets the background color to bright white.
      #
      # @param [String, nil] string
      #   An optional string.
      #
      # @return [String, ON_BRIGHT_WHITE]
      #   The colorized string or just {ON_BRIGHT_WHITE} if no arguments were
      #   given.
      #
      # @see ON_BRIGHT_WHITE
      #
      # @api public
      #
      # @since 0.3.0
      #
      def on_bright_white(string=nil)
        if string then "#{ON_BRIGHT_WHITE}#{string}#{RESET_BG}"
        else           ON_BRIGHT_WHITE
        end
      end
    end
  end
end
