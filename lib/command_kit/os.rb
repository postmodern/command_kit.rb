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
    def linux?
      RUBY_PLATFORM.include?('linux')
    end

    #
    # Determines if the current OS is macOS.
    #
    # @return [Boolean]
    #
    def macos?
      RUBY_PLATFORM.include?('darwin')
    end

    #
    # Determines if the current OS is Windows.
    #
    # @return [Boolean]
    #
    def windows?
      Gem.win_platform?
    end
  end
end
