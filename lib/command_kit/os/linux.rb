require 'command_kit/os'

module CommandKit
  module OS
    #
    # Provides methods for determining the specific type of Linux.
    #
    # @since 0.2.0
    #
    module Linux
      include OS

      #
      # Determines if the current OS is RedHat Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def redhat_linux?
        linux? && File.file?('/etc/redhat-release')
      end

      #
      # Determines if the current OS is Fedora Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def fedora_linux?
        linux? && File.file?('/etc/fedora-release')
      end

      #
      # Determines if the current OS is Debian Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def debian_linux?
        linux? && File.file?('/etc/debian_version')
      end

      #
      # Determines if the current OS is SuSE Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def suse_linux?
        linux? && File.file?('/etc/SuSE-release')
      end

      #
      # Determines if the current OS is Arch Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def arch_linux?
        linux? && File.file?('/etc/arch-release')
      end

      #
      # Determines the specific Linux distro.
      #
      # @return [:fedora, :redhat, :debian, :suse, :arch, nil]
      #   Returns the type of Linux distro or `nil` if the Linux distro could
      #   not be determined.
      #
      # @api public
      #
      def linux_distro
        if    fedora_linux? then :fedora
        elsif redhat_linux? then :redhat
        elsif debian_linux? then :debian
        elsif suse_linux?   then :suse
        elsif arch_linux?   then :arch
        end
      end
    end
  end
end
