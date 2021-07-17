module CommandKit
  #
  # Provides methods for determining the current OS.
  #
  # ## Examples
  #
  #     include CommandKit::OS
  #     
  #     def main(*argv)
  #       if linux?
  #         # ...
  #       elsif macos?
  #         # ...
  #       elsif freebsd?
  #         # ...
  #       elsif windows?
  #         # ...
  #       end
  #     end
  #
  module OS
    #
    # Determines if the current OS is Linux.
    #
    # @return [Boolean]
    #
    # @api public
    #
    def linux?
      RUBY_PLATFORM.include?('linux')
    end

    #
    # Determines if the current OS is macOS.
    #
    # @return [Boolean]
    #
    # @api public
    #
    def macos?
      RUBY_PLATFORM.include?('darwin')
    end

    #
    # Determines if the current OS is FreeBSD.
    #
    # @return [Boolean]
    #
    # @api public
    #
    # @since 0.2.0
    #
    def freebsd?
      RUBY_PLATFORM.include?('freebsd')
    end

    #
    # Determines if the current OS is UNIX based.
    #
    # @return [Boolean]
    #
    # @since 0.2.0
    #
    # @api public
    #
    def unix?
      linux? || macos? || freebsd?
    end

    #
    # Determines if the current OS is Windows.
    #
    # @return [Boolean]
    #
    # @api public
    #
    def windows?
      Gem.win_platform?
    end
  end
end
