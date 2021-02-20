# frozen_string_literal: true

module CommandKit
  #
  # Defines ANSI color codes.
  #
  module ANSI

    #
    # ANSI foreground color codes.
    #
    module FG
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

      # ANSI color code for megenta
      MAGENTA = "\e[35m"

      # ANSI color code for cyan
      CYAN = "\e[36m"

      # ANSI color code for white
      WHITE = "\e[37m"

      # ANSI color code for bright black
      BRIGHT_BLACK = "\e[90m"

      # @see BRIGHT_BLACK
      BRIGHT_GRAY = BRIGHT_BLACK

      # ANSI color code for bright red
      BRIGHT_RED = "\e[91m"

      # ANSI color code for bright green
      BRIGHT_GREEN = "\e[92m"

      # ANSI color code for bright yellow
      BRIGHT_YELLOW = "\e[93m"

      # ANSI color code for bright blue
      BRIGHT_BLUE = "\e[94m"

      # ANSI color code for bright megenta
      BRIGHT_MEGENTA = "\e[95m"

      # ANSI color code for bright cyan
      BRIGHT_CYAN = "\e[96m"

      # ANSI color code for bright white
      BRIGHT_WHITE = "\e[97m"
    end

    #
    # ANSI background color codes.
    #
    module BG
      # ANSI color code for black
      BLACK = "\e[40m"

      # ANSI color code for red
      RED = "\e[41m"

      # ANSI color code for green
      GREEN = "\e[42m"

      # ANSI color code for yellow
      YELLOW = "\e[43m"

      # ANSI color code for blue
      BLUE = "\e[44m"

      # ANSI color code for megenta
      MAGENTA = "\e[45m"

      # ANSI color code for cyan
      CYAN = "\e[46m"

      # ANSI color code for white
      WHITE = "\e[47m"

      # ANSI color code for bright black
      BRIGHT_BLACK = "\e[100m"

      # @see BRIGHT_BLACK
      BRIGHT_GRAY = BRIGHT_BLACK

      # ANSI color code for bright red
      BRIGHT_RED = "\e[101m"

      # ANSI color code for bright green
      BRIGHT_GREEN = "\e[102m"

      # ANSI color code for bright yellow
      BRIGHT_YELLOW = "\e[103m"

      # ANSI color code for bright blue
      BRIGHT_BLUE = "\e[104m"

      # ANSI color code for bright megenta
      BRIGHT_MEGENTA = "\e[105m"

      # ANSI color code for bright cyan
      BRIGHT_CYAN = "\e[106m"

      # ANSI color code for bright white
      BRIGHT_WHITE = "\e[107m"
    end

    include FG

    # ANSI code for bold text
    BOLD = "\e[1m"

    # ANSI reset code
    RESET = "\e[0m"

    # @see RESET
    CLEAR = RESET

    module_function

    #
    # Checks if the stream supports ANSI output.
    #
    # @param [IO] stream
    #
    # @return [Boolean]
    #
    def color?(stream)
      ENV['TERM'] != 'dumb' && stream.tty?
    end

    #
    # @see BLACK
    #
    def black
      BLACK
    end

    #
    # @see RED
    #
    def red
      RED
    end

    #
    # @see GREEN
    #
    def green
      GREEN
    end

    #
    # @see YELLOW
    #
    def yellow
      YELLOW
    end

    #
    # @see BLUE
    #
    def blue
      BLUE
    end

    #
    # @see MAGENTA
    #
    def magenta
      MAGENTA
    end

    #
    # @see CYAN
    #
    def cyan
      CYAN
    end

    #
    # @see WHITE
    #
    def white
      WHITE
    end

    #
    # @see BRIGHT_BLACK
    #
    def bright_black
      BRIGHT_BLACK
    end

    #
    # @see BRIGHT_GRAY
    #
    def bright_gray
      BRIGHT_GRAY
    end

    #
    # @see BRIGHT_RED
    #
    def bright_red
      BRIGHT_RED
    end

    #
    # @see BRIGHT_GREEN
    #
    def bright_green
      BRIGHT_GREEN
    end

    #
    # @see BRIGHT_YELLOW
    #
    def bright_yellow
      BRIGHT_YELLOW
    end

    #
    # @see BRIGHT_BLUE
    #
    def bright_blue
      BRIGHT_BLUE
    end

    #
    # @see BRIGHT_MEGENTA
    #
    def bright_magenta
      BRIGHT_MAGENTA
    end

    #
    # @see BRIGHT_CYAN
    #
    def bright_cyan
      BRIGHT_CYAN
    end

    #
    # @see BRIGHT_WHITE
    #
    def bright_white
      BRIGHT_WHITE
    end

    #
    # @see BOLD
    #
    def bold
      BOLD
    end

    #
    # @see RESET
    #
    def reset
      RESET
    end

    #
    # @see CLEAR
    #
    def clear
      CLEAR
    end

  end
end
