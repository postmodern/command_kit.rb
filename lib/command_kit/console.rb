require 'command_kit/stdio'

require 'io/console'

module CommandKit
  #
  # Provides access to [IO.console] and [IO#winsize].
  #
  # [IO.console]: https://rubydoc.info/gems/io-console/IO#console-class_method
  # [IO#winsize]: https://rubydoc.info/gems/io-console/IO#winsize-instance_method
  #
  module Console
    include Stdio

    #
    # Determines if {Stdio#stdout stdout} is connected to a console.
    #
    # @return [Boolean]
    #
    def console?
      stdout.tty?
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
    # The console height (rows) and width (columns).
    #
    # @return [(Integer, Integer), nil]
    #   Returns the height and width of the console, or `nil` if
    #   {Stdio#stdout stdout} is not connected to a console.
    #
    # @example
    #   console_size
    #   # => [23, 91]
    #
    def console_size
      if (console = self.console)
        begin
          console.winsize
        rescue Errno::ENOTTY
        end
      end
    end

    #
    # Returns the console's height in number of lines.
    #
    # @return [Integer, nil]
    #   The console's height or `nil` if {Stdio#stdout stdout} is not connected
    #   to a console.
    #
    # @example
    #   console_height
    #   # => 22
    #
    def console_height
      height, width = console_size
      height
    end

    #
    # Returns the console's height in number of lines.
    #
    # @return [Integer, nil]
    #   The console's width or `nil` if {Stdio#stdout stdout} is not connected
    #   to a console.
    #
    # @example
    #   console_width
    #   # => 91
    #
    def console_width
      height, width = console_size
      width
    end
  end
end
