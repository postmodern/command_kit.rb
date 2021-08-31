module CommandKit
  #
  # Provides methods for determining the current OS.
  #
  # ## Examples
  #
  #     require 'command_kit/command'
  #     require 'command_kit/os'
  #     
  #     class Command < CommandKit::Command
  #     
  #       include CommandKit::OS
  #     
  #       def main(*argv)
  #         if linux?
  #           # ...
  #         elsif macos?
  #           # ...
  #         elsif freebsd?
  #           # ...
  #         elsif windows?
  #           # ...
  #         end
  #       end
  #     
  #     end
  #
  module OS
    #
    # @api private
    #
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether
      # {OS} is being included into a class or a module..
      #
      # @param [Class, Module] context
      #   The class or module which is including {OS}.
      #
      def included(context)
        super(context)

        if context.class == Module
          context.extend ModuleMethods
        else
          context.extend ClassMethods
        end
      end
    end

    extend ModuleMethods

    module ClassMethods
      #
      # Determines the current OS.
      #
      # @return [:linux, :macos, :freebsd, :openbsd, :netbsd, :windows, nil]
      #   The OS type or `nil` if the OS could not be determined.
      #
      # @api semipublic
      #
      # @since 0.2.0
      #
      def os
        if    RUBY_PLATFORM.include?('linux')   then :linux
        elsif RUBY_PLATFORM.include?('darwin')  then :macos
        elsif RUBY_PLATFORM.include?('freebsd') then :freebsd
        elsif RUBY_PLATFORM.include?('openbsd') then :openbsd
        elsif RUBY_PLATFORM.include?('netbsd')  then :netbsd
        elsif Gem.win_platform?                 then :windows
        end
      end
    end

    # The current OS.
    #
    # @return [:linux, :macos, :freebsd, :openbsd, :netbsd, :windows, nil]
    #
    # @api public
    #
    # @since 0.2.0
    attr_reader :os

    #
    # Initializes the command.
    #
    # @param [:linux, :macos, :freebsd, :openbsd, :netbsd, :windows, nil] os
    #   Overrides the default OS.
    #   
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @api public
    #
    # @since 0.2.0
    #
    def initialize(os: self.class.os, **kwargs)
      super(**kwargs)

      @os = os
    end

    #
    # Determines if the current OS is Linux.
    #
    # @return [Boolean]
    #
    # @api public
    #
    def linux?
      @os == :linux
    end

    #
    # Determines if the current OS is macOS.
    #
    # @return [Boolean]
    #
    # @api public
    #
    def macos?
      @os == :macos
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
      @os == :freebsd
    end

    #
    # Determines if the current OS is OpenBSD.
    #
    # @return [Boolean]
    #
    # @api public
    #
    # @since 0.2.0
    #
    def openbsd?
      @os == :openbsd
    end

    #
    # Determines if the current OS is NetBSD.
    #
    # @return [Boolean]
    #
    # @api public
    #
    # @since 0.2.0
    #
    def netbsd?
      @os == :netbsd
    end

    #
    # Determines if the current OS is BSD based.
    #
    # @return [Boolean]
    #
    # @since 0.2.0
    #
    # @api public
    #
    def bsd?
      freebsd? || openbsd? || netbsd?
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
      linux? || macos? || bsd?
    end

    #
    # Determines if the current OS is Windows.
    #
    # @return [Boolean]
    #
    # @api public
    #
    def windows?
      @os == :windows
    end
  end
end
