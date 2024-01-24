require_relative 'stdio'
require_relative 'env'

begin
  require 'io/console'
rescue LoadError
end

module CommandKit
  #
  # Provides direct access to the terminal.
  #
  # ## Environment Variables
  #
  # * `LINES` - The explicit number of lines or rows the console should have.
  # * `COLUMNS` - The explicit number of columns the console should have.
  #
  # @see https://rubydoc.info/gems/io-console/IO
  #
  module Terminal
    include Stdio
    include Env

    # The default terminal height to fallback to.
    DEFAULT_TERMINAL_HEIGHT = 25

    # The default terminal width to fallback to.
    DEFAULT_TERMINAL_WIDTH = 80

    #
    # Initializes any terminal settings.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @note
    #   If the `$LINES` env variable is set, and is non-zero, it will be
    #   returned by {#terminal_height}.
    #
    # @note
    #   If the `$COLUMNS` env variable is set, and is non-zero, it will be
    #   returned by {#terminal_width}.
    #
    # @api public
    #
    def initialize(**kwargs)
      super(**kwargs)

      @terminal_height = if (lines = env['LINES'])
                           lines.to_i
                         else
                           DEFAULT_TERMINAL_HEIGHT
                         end

      @terminal_width  = if (columns = env['COLUMNS'])
                           columns.to_i
                         else
                           DEFAULT_TERMINAL_WIDTH
                         end
    end

    #
    # Determines if program is running in a terminal.
    #
    # @return [Boolean]
    #   Specifies whether {Stdio#stdout stdout} is connected to a terminal.
    #
    # @api public
    #
    def terminal?
      IO.respond_to?(:console) && stdout.tty?
    end

    #
    # @since 0.2.0
    #
    alias tty? terminal?

    #
    # Returns the terminal object, if {Stdio#stdout stdout} is connected to a
    # terminal.
    #
    # @return [IO, nil]
    #   The IO objects or `nil` if {Stdio#stdout stdout} is not connected to a
    #   terminal.
    #
    # @example
    #   terminal
    #   # => #<File:/dev/tty>
    #
    # @see https://rubydoc.info/gems/io-console/IO
    #
    # @api semipublic
    #
    def terminal
      IO.console if terminal?
    end

    #
    # Returns the terminal's height in number of lines.
    #
    # @return [Integer]
    #   The terminal's height in number of lines.
    #
    # @example
    #   terminal_height
    #   # => 22
    #
    # @api public
    #
    def terminal_height
      if (terminal = self.terminal)
        terminal.winsize[0]
      else
        @terminal_height
      end
    end

    #
    # Returns the terminal's width in number of lines.
    #
    # @return [Integer]
    #   The terminal's width in number of columns.
    #
    # @example
    #   terminal_width
    #   # => 91
    #
    # @api public
    #
    def terminal_width
      if (terminal = self.terminal)
        terminal.winsize[1]
      else
        @terminal_width
      end
    end

    #
    # The terminal height (lines) and width (columns).
    #
    # @return [(Integer, Integer)]
    #   Returns the height and width of the terminal.
    #
    # @example
    #   terminal_size
    #   # => [23, 91]
    #
    # @api public
    #
    def terminal_size
      if (terminal = self.terminal)
        terminal.winsize
      else
        [@terminal_height, @terminal_width]
      end
    end
  end
end
