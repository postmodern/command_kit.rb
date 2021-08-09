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
  # ## Environment Variables
  #
  # * `TERM` - Specifies the type of terminal. When set to `DUMB`, it will
  #   disable color output.
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

      # ANSI color code for bg black
      #
      # @since 0.2.0
      ON_BLACK = "\e[40m"

      # ANSI color code for bg red
      #
      # @since 0.2.0
      ON_RED = "\e[41m"

      # ANSI color code for bg green
      #
      # @since 0.2.0
      ON_GREEN = "\e[42m"

      # ANSI color code for bg yellow
      #
      # @since 0.2.0
      ON_YELLOW = "\e[43m"

      # ANSI color code for bg blue
      #
      # @since 0.2.0
      ON_BLUE = "\e[44m"

      # ANSI color code for bg megenta
      #
      # @since 0.2.0
      ON_MAGENTA = "\e[45m"

      # ANSI color code for bg cyan
      #
      # @since 0.2.0
      ON_CYAN = "\e[46m"

      # ANSI color code for bg white
      #
      # @since 0.2.0
      ON_WHITE = "\e[47m"

      # ANSI color for the default background color
      #
      # @since 0.2.0
      RESET_BG = "\e[49m"

      module_function

      #
      # Resets text formatting.
      #
      # @return [RESET]
      #
      # @see RESET
      #
      # @api public
      #
      def reset
        RESET
      end

      #
      # @see reset
      #
      # @api public
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
      # @api public
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
      # @api public
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
      # @api public
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
      # @api public
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
      # @api public
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
      # @api public
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
      # @api public
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
      # @api public
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
      # @api public
      #
      def white(string=nil)
        if string then "#{WHITE}#{string}#{RESET_COLOR}"
        else           WHITE
        end
      end

      #
      # Sets the bg color to black.
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
      # Sets the bg color to red.
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
      # Sets the bg color to green.
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
      # Sets the bg color to yellow.
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
      # Sets the bg color to blue.
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
      # Sets the bg color to magenta.
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
      # Sets the bg color to cyan.
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
      # Sets the bg color to white.
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
    end

    #
    # Dummy module with the same interface as {ANSI}, but for when ANSI is not
    # supported.
    #
    module PlainText
      ANSI.constants(false).each do |name|
        const_set(name,'')
      end

      module_function

      def reset
        RESET
      end

      def clear
        reset
      end

      [
        :bold, :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white,
        :on_black, :on_red, :on_green, :on_yellow, :on_blue, :on_magenta, :on_cyan, :on_white
      ].each do |name|
        define_method(name) do |string=nil|
          string || ''
        end
      end
    end

    #
    # Checks if the stream supports ANSI output.
    #
    # @param [IO] stream
    #
    # @return [Boolean]
    #
    # @note
    #   When the env variable `TERM` is set to `dumb`, it will disable color
    #   output. Color output will also be disabled if the given stream is not
    #   a TTY.
    #
    # @api public
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
    # @example
    #   puts colors.green("Hello world")
    #
    # @example Using colors with stderr output:
    #   stderr.puts colors(stderr).green("Hello world")
    #
    # @api public
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
