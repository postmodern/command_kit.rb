# frozen_string_literal: true

require_relative 'colors/ansi'
require_relative 'colors/plain_text'

require_relative 'stdio'
require_relative 'env'

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
  # * [ansi](https://rubyworks.github.io/ansi/)
  # * [colorize](https://github.com/fazibear/colorize#readme)
  #
  # @see https://en.wikipedia.org/wiki/ANSI_escape_code
  #
  module Colors

    include Stdio
    include Env

    #
    # Checks if the stream supports ANSI output.
    #
    # @param [IO] stream
    #
    # @return [Boolean]
    #
    # @note
    #   When the env variable `TERM` is set to `dumb` or when the `NO_COLOR`
    #   env variable is set, it will disable color output. Color output will
    #   also be disabled if the given stream is not a TTY.
    #
    # @api public
    #
    def ansi?(stream=stdout)
      env['TERM'] != 'dumb' && !env['NO_COLOR'] && stream.tty?
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
