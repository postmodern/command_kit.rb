# frozen_string_literal: true

require 'command_kit/stdio'
require 'command_kit/env'

module CommandKit
  #
  # Defines ANSI color codes.
  #
  # ## Examples
  #
  #     include CommandKit::Colors
  #
  #     def run
  #       puts colors.green("hello world")
  #     end
  #
  # ### Printing color error messages
  #
  #     stderr.puts colors(stderr).red("error!")
  #
  # ## Alternatives
  #
  # * [ansi](http://rubyworks.github.io/ansi/)
  # * [colorize](https://github.com/fazibear/colorize#readme)
  #
  module Colors

    include Stdio
    include Env

    #
    # ANSI foreground color codes.
    #
    module Color
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

      # ANSI code for bold text
      BOLD = "\e[1m"

      # ANSI reset code
      RESET = "\e[0m"

      # @see RESET
      CLEAR = RESET

      module_function

      #
      # @see BLACK
      #
      def black(string=nil)
        if string then "#{BLACK}#{string}#{RESET}"
        else           BLACK
        end
      end

      #
      # @see RED
      #
      def red(string=nil)
        if string then "#{RED}#{string}#{RESET}"
        else           RED
        end
      end

      #
      # @see GREEN
      #
      def green(string=nil)
        if string then "#{GREEN}#{string}#{RESET}"
        else           GREEN
        end
      end

      #
      # @see YELLOW
      #
      def yellow(string=nil)
        if string then "#{YELLOW}#{string}#{RESET}"
        else           YELLOW
        end
      end

      #
      # @see BLUE
      #
      def blue(string=nil)
        if string then "#{BLUE}#{string}#{RESET}"
        else           BLUE
        end
      end

      #
      # @see MAGENTA
      #
      def magenta(string=nil)
        if string then "#{MAGENTA}#{string}#{RESET}"
        else           MAGENTA
        end
      end

      #
      # @see CYAN
      #
      def cyan(string=nil)
        if string then "#{CYAN}#{string}#{RESET}"
        else           CYAN
        end
      end

      #
      # @see WHITE
      #
      def white(string=nil)
        if string then "#{WHITE}#{string}#{RESET}"
        else           WHITE
        end
      end

      #
      # @see BRIGHT_BLACK
      #
      def bright_black(stirng=nil)
        if string then "#{BRIGHT_BLACK}#{string}#{RESET}"
        else           BRIGHT_BLACK
        end
      end

      #
      # @see BRIGHT_GRAY
      #
      def bright_gray(string=nil)
        if string then "#{BRIGHT_GRAY}#{string}#{RESET}"
        else           BRIGHT_GRAY
        end
      end

      #
      # @see BRIGHT_RED
      #
      def bright_red(string=nil)
        if string then "#{BRIGHT_RED}#{string}#{RESET}"
        else           BRIGHT_RED
        end
      end

      #
      # @see BRIGHT_GREEN
      #
      def bright_green(string=nil)
        if string then "#{BRIGHT_GREEN}#{string}#{RESET}"
        else           BRIGHT_GREEN
        end
      end

      #
      # @see BRIGHT_YELLOW
      #
      def bright_yellow(string=nil)
        if string then "#{BRIGHT_YELLOW}#{string}#{RESET}"
        else           BRIGHT_YELLOW
        end
      end

      #
      # @see BRIGHT_BLUE
      #
      def bright_blue(string=nil)
        if string then "#{BRIGHT_BLUE}#{string}#{RESET}"
        else           BRIGHT_BLUE
        end
      end

      #
      # @see BRIGHT_MEGENTA
      #
      def bright_magenta(string=nil)
        if string then "#{BRIGHT_MAGENTA}#{string}#{RESET}"
        else           BRIGHT_MAGENTA
        end
      end

      #
      # @see BRIGHT_CYAN
      #
      def bright_cyan(string=nil)
        if string then "#{BRIGHT_CYAN}#{string}#{RESET}"
        else           BRIGHT_CYAN
        end
      end

      #
      # @see BRIGHT_WHITE
      #
      def bright_white(string=nil)
        if string then "#{BRIGHT_WHITE}#{string}#{RESET}"
        else           BRIGHT_WHITE
        end
      end

      #
      # @see BOLD
      #
      def bold(string=nil)
        if string then "#{BOLD}#{string}#{RESET}"
        else           BOLD
        end
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
        reset
      end
    end

    module NoColor
      BLACK = RED = GREEN = YELLOW = BLUE = MAGENTA = CYAN = WHITE = \
        BRIGHT_BLACK = BRIGHT_GRAY = BRIGHT_RED = BRIGHT_GREEN = \
        BRIGHT_YELLOW = BRIGHT_BLUE = BRIGHT_MEGENTA = BRIGHT_CYAN = \
        BRIGHT_WHITE = BOLD = RESET = CLEAR = ''

      module_function

      #
      # @see BLACK
      #
      def black(string=nil)
        string || ''
      end

      #
      # @see RED
      #
      def red(string=nil)
        string || ''
      end

      #
      # @see GREEN
      #
      def green(string=nil)
        string || ''
      end

      #
      # @see YELLOW
      #
      def yellow(string=nil)
        string || ''
      end

      #
      # @see BLUE
      #
      def blue(string=nil)
        string || ''
      end

      #
      # @see MAGENTA
      #
      def magenta(string=nil)
        string || ''
      end

      #
      # @see CYAN
      #
      def cyan(string=nil)
        string || ''
      end

      #
      # @see WHITE
      #
      def white(string=nil)
        string || ''
      end

      #
      # @see BRIGHT_BLACK
      #
      def bright_black(stirng=nil)
        string || ''
      end

      #
      # @see BRIGHT_GRAY
      #
      def bright_gray(string=nil)
        string || ''
      end

      #
      # @see BRIGHT_RED
      #
      def bright_red(string=nil)
        string || ''
      end

      #
      # @see BRIGHT_GREEN
      #
      def bright_green(string=nil)
        string || ''
      end

      #
      # @see BRIGHT_YELLOW
      #
      def bright_yellow(string=nil)
        string || ''
      end

      #
      # @see BRIGHT_BLUE
      #
      def bright_blue(string=nil)
        string || ''
      end

      #
      # @see BRIGHT_MEGENTA
      #
      def bright_magenta(string=nil)
        string || ''
      end

      #
      # @see BRIGHT_CYAN
      #
      def bright_cyan(string=nil)
        string || ''
      end

      #
      # @see BRIGHT_WHITE
      #
      def bright_white(string=nil)
        string || ''
      end

      #
      # @see BOLD
      #
      def bold(string=nil)
        string || ''
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
        reset
      end
    end

    #
    # Checks if the stream supports ANSI output.
    #
    # @param [IO] stream
    #
    # @return [Boolean]
    #
    def colors?(stream=stdout)
      env['TERM'] != 'dumb' && stream.tty?
    end

    #
    # @param [IO] stream
    #
    # @return [Color, NoColor]
    #
    def colors(stream=stdout)
      color = if colors?(stream) then Color
              else                    NoColor
              end

      yield color if block_given?
      return color
    end

  end
end
