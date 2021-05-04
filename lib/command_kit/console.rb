require 'command_kit/stdio'
require 'command_kit/env'

begin
  require 'io/console'
rescue LoadError
end

module CommandKit
  #
  # Provides access to [IO.console] and [IO.console_size].
  #
  # ## Environment Variables
  #
  # * `LINES` - The explicit number of lines or rows the console should have.
  # * `COLUMNS` - The explicit number of columns the console should have.
  #
  # [IO.console]: https://rubydoc.info/gems/io-console/IO#console-class_method
  # [IO#winsize]: https://rubydoc.info/gems/io-console/IO#winsize-instance_method
  #
  module Console
    include Stdio
    include Env

    # The default console height to fallback to.
    DEFAULT_HEIGHT = 25

    # The default console width to fallback to.
    DEFAULT_WIDTH = 80

    #
    # Initializes any console settings.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @note
    #   If the `$LINES` env variable is set, and is non-zero, it will be
    #   returned by {#console_height}.
    #
    # @note
    #   If the `$COLUMNS` env variable is set, and is non-zero, it will be
    #   returned by {#console_width}.
    #
    def initialize(**kwargs)
      super(**kwargs)

      @default_console_height = if (lines = env['LINES'])
                                  lines.to_i
                                else
                                  DEFAULT_HEIGHT
                                end

      @default_console_width  = if (columns = env['COLUMNS'])
                                  columns.to_i
                                else
                                  DEFAULT_WIDTH
                                end
    end

    #
    # Determines if there is a console present.
    #
    # @return [Boolean]
    #   Specifies whether {Stdio#stdout stdout} is connected to a console.
    #
    def console?
      IO.respond_to?(:console) && stdout.tty?
    end

    #
    # Returns the console object, if {Stdio#stdout stdout} is connected to a
    # console.
    #
    # @return [IO, nil]
    #   The IO objects or `nil` if {Stdio#stdout stdout} is not connected to a
    #   console.
    #
    # @example
    #   console
    #   # => #<File:/dev/tty>
    #
    def console
      IO.console if console?
    end

    #
    # Returns the console's height in number of lines.
    #
    # @return [Integer]
    #   The console's height in number of lines.
    #
    # @example
    #   console_height
    #   # => 22
    #
    def console_height
      if (console = self.console)
        console.winsize[0]
      else
        @default_console_height
      end
    end

    #
    # Returns the console's width in number of lines.
    #
    # @return [Integer]
    #   The console's width in number of columns.
    #
    # @example
    #   console_width
    #   # => 91
    #
    def console_width
      if (console = self.console)
        console.winsize[1]
      else
        @default_console_width
      end
    end

    #
    # The console height (lines) and width (columns).
    #
    # @return [(Integer, Integer)]
    #   Returns the height and width of the console.
    #
    # @example
    #   console_size
    #   # => [23, 91]
    #
    def console_size
      if (console = self.console)
        console.winsize
      else
        [@default_console_height, @default_console_width]
      end
    end
  end
end
