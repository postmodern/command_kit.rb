require_relative '../os'

module CommandKit
  module OS
    #
    # Provides methods for determining the specific type of Linux.
    #
    # ## Example
    #
    #     require 'command_kit/command'
    #     require 'command_kit/os/linux'
    #     
    #     class Command < CommandKit::Command
    #     
    #       include CommandKit::OS::Linux
    #     
    #       def run
    #         if debian_linux?
    #           # ...
    #         elsif redhat_linux?
    #           # ...
    #         elsif suse_linux?
    #           # ...
    #         elsif arch_linux?
    #           # ...
    #         end
    #       end
    #     end
    #
    # @since 0.2.0
    #
    module Linux
      #
      # @api private
      #
      module ModuleMethods
        #
        # Extends {ClassMethods} or {ModuleMethods}, depending on whether
        # {OS} is being included into a class or a module.
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
        # Determines the specific Linux distro.
        #
        # @return [:fedora, :redhat, :debian, :suse, :arch, nil]
        #   Returns the type of Linux distro or `nil` if the Linux distro could
        #   not be determined.
        #
        # @api semipublic
        #
        def linux_distro
          if    File.file?('/etc/fedora-release') then :fedora
          elsif File.file?('/etc/redhat-release') then :redhat
          elsif File.file?('/etc/debian_version') then :debian
          elsif File.file?('/etc/SuSE-release')   then :suse
          elsif File.file?('/etc/arch-release')   then :arch
          end
        end
      end

      # The Linux distro.
      #
      # @return [:fedora, :redhat, :debian, :suse, :arch, nil]
      #
      # @api public
      attr_reader :linux_distro

      #
      # Initializes the command.
      #
      # @param [:fedora, :redhat, :debian, :suse, :arch, nil] linux_distro
      #   Overrides the default detected Linux distro.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @api public
      #
      def initialize(linux_distro: self.class.linux_distro, **kwargs)
        super(**kwargs)

        @linux_distro = linux_distro
      end

      #
      # Determines if the current OS is RedHat Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def redhat_linux?
        @linux_distro == :redhat
      end

      #
      # Determines if the current OS is Fedora Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def fedora_linux?
        @linux_distro == :fedora
      end

      #
      # Determines if the current OS is Debian Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def debian_linux?
        @linux_distro == :debian
      end

      #
      # Determines if the current OS is SUSE Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def suse_linux?
        @linux_distro == :suse
      end

      #
      # Determines if the current OS is Arch Linux based distro.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def arch_linux?
        @linux_distro == :arch
      end
    end
  end
end
