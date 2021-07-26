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
      # @group Linux
      #
      # @api public
      #
      # @since 0.2.0
      #
      def redhat_linux?
        linux? && File.file?('/etc/redhat-release')
      end

      #
      # Determines if the current OS is Fedora Linux based distro.
      #
      # @return [Boolean]
      #
      # @group Linux
      #
      # @api public
      #
      # @since 0.2.0
      #
      def fedora_linux?
        linux? && File.file?('/etc/fedora-release')
      end

      #
      # Determines if the current OS is Debian Linux based distro.
      #
      # @return [Boolean]
      #
      # @group Linux
      #
      # @api public
      #
      # @since 0.2.0
      #
      def debian_linux?
        linux? && File.file?('/etc/debian_version')
      end

      #
      # Determines if the current OS is SuSE Linux based distro.
      #
      # @return [Boolean]
      #
      # @group Linux
      #
      # @api public
      #
      # @since 0.2.0
      #
      def suse_linux?
        linux? && File.file?('/etc/SuSE-release')
      end

      #
      # Determines if the current OS is Arch Linux based distro.
      #
      # @return [Boolean]
      #
      # @group Linux
      #
      # @api public
      #
      # @since 0.2.0
      #
      def arch_linux?
        linux? && File.file?('/etc/arch-release')
      end
    end
  end
end
