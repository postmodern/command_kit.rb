# frozen_string_literal: true

module CommandKit
  #
  # Defines ANSI color codes.
  #
  module ANSI

    BLACK = "\e[30m"

    RED = "\e[31m"

    GREEN = "\e[32m"

    YELLOW = "\e[33m"

    BLUE = "\e[34m"

    MAGENTA = "\e[35m"

    CYAN = "\e[36m"

    WHITE = "\e[37m"

    BRIGHT_BLACK = "\e[90m"

    BRIGHT_GRAY = BRIGHT_BLACK

    BRIGHT_RED = "\e[91m"

    BRIGHT_GREEN = "\e[92m"

    BRIGHT_YELLOW = "\e[93m"

    BRIGHT_BLUE = "\e[94m"

    BRIGHT_MEGENTA = "\e[95m"

    BRIGHT_CYAN = "\e[96m"

    BRIGHT_WHITE = "\e[97m"

    BOLD = "\e[1m"

    RESET = "\e[0m"

    CLEAR = RESET

    module_function

    def color?(stream)
      ENV['TERM'] != 'dumb' && stream.tty?
    end

    def black
      BLACK
    end

    def red
      RED
    end

    def green
      GREEN
    end

    def yellow
      YELLOW
    end

    def blue
      BLUE
    end

    def magenta
      MAGENTA
    end

    def cyan
      CYAN
    end

    def white
      WHITE
    end

    def bright_black
      BRIGHT_BLACK
    end

    def bright_gray
      BRIGHT_GRAY
    end

    def bright_red
      BRIGHT_RED
    end

    def bright_green
      BRIGHT_GREEN
    end

    def bright_yellow
      BRIGHT_YELLOW
    end

    def bright_blue
      BRIGHT_BLUE
    end

    def bright_magenta
      BRIGHT_MAGENTA
    end

    def bright_cyan
      BRIGHT_CYAN
    end

    def bright_white
      BRIGHT_WHITE
    end

    def bold
      BOLD
    end

    def reset
      RESET
    end

    def clear
      CLEAR
    end

  end
end
