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
  # @see https://en.wikipedia.org/wiki/ANSI_escape_code
  #
  module Colors

    include Stdio
    include Env

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

      # ANSI color code for megenta
      MAGENTA = "\e[35m"

      # ANSI color code for cyan
      CYAN = "\e[36m"

      # ANSI color code for white
      WHITE = "\e[37m"

      # ANSI color for the default foreground color
      RESET_COLOR = "\e[39m"

      module_function

      #
      # Resets text formatting.
      #
      # @return [RESET]
      #
      # @see RESET
      #
      def reset
        RESET
      end

      #
      # @see reset
      #
      def clear
        reset
      end

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
      def bold(string=nil)
        if string then "#{BOLD}#{string}#{RESET_INTENSITY}"
        else           BOLD
        end
      end

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
      def black(string=nil)
        if string then "#{BLACK}#{string}#{RESET_COLOR}"
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
      def red(string=nil)
        if string then "#{RED}#{string}#{RESET_COLOR}"
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
      def green(string=nil)
        if string then "#{GREEN}#{string}#{RESET_COLOR}"
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
      def yellow(string=nil)
        if string then "#{YELLOW}#{string}#{RESET_COLOR}"
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
      def blue(string=nil)
        if string then "#{BLUE}#{string}#{RESET_COLOR}"
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
      def magenta(string=nil)
        if string then "#{MAGENTA}#{string}#{RESET_COLOR}"
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
      def cyan(string=nil)
        if string then "#{CYAN}#{string}#{RESET_COLOR}"
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
      def white(string=nil)
        if string then "#{WHITE}#{string}#{RESET_COLOR}"
        else           WHITE
        end
      end
    end

    #
    # Dummy module with the same interface as {ANSI}, but for when ANSI is not
    # supported.
    #
    module PlainText
      RESET = \
        CLEAR = \
        BOLD = \
        RESET_INTENSITY = \
        BLACK = \
        RED = \
        GREEN = \
        YELLOW = \
        BLUE = \
        MAGENTA = \
        CYAN = \
        WHITE = \
        RESET_COLOR = ''

      module_function

      def reset
        RESET
      end

      def clear
        reset
      end

      def bold(string=nil)
        string || ''
      end

      def black(string=nil)
        string || ''
      end

      def red(string=nil)
        string || ''
      end

      def green(string=nil)
        string || ''
      end

      def yellow(string=nil)
        string || ''
      end

      def blue(string=nil)
        string || ''
      end

      def magenta(string=nil)
        string || ''
      end

      def cyan(string=nil)
        string || ''
      end

      def white(string=nil)
        string || ''
      end
    end

    #
    # Checks if the stream supports ANSI output.
    #
    # @param [IO] stream
    #
    # @return [Boolean]
    #
    def ansi?(stream=stdout)
      env['TERM'] != 'dumb' && stream.tty?
    end

    #
    # Returns the colors available for the given stream.
    #
    # @param [IO] stream
    #
    # @return [ANSI, PlainText]
    #   The ANSI module or PlainText dummy module.
    #
    def colors(stream=stdout)
      color = if ansi?(stream) then ANSI
              else                  PlainText
              end

      yield color if block_given?
      return color
    end
  end
end
