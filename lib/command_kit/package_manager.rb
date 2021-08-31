require 'command_kit/os'
require 'command_kit/os/linux'
require 'command_kit/env/path'
require 'command_kit/sudo'

module CommandKit
  #
  # Allows installing packages using the system's package manager.
  #
  # Supports the following package managers:
  #
  # * Linux
  #   * Debian / Ubuntu
  #     * `apt`
  #   * RedHat / Fedora
  #     * `dnf`
  #     * `yum`
  #   * Arch
  #     * `pacman`
  #   * SUSE / OpenSUSE
  #     * `zypper`
  # * macOS
  #   * `brew`
  #   * `port`
  # * FreeBSD
  #   * `pkg`
  # * OpenBSD
  #   * `pkg_add`
  #
  # ## Examples
  #
  #     unless install_packages("nmap")
  #       print_error "failed to install nmap"
  #       exit -1
  #     end
  #
  # ### Installing multiple packages
  #
  #     install_packages apt: ["libxml2-dev", ...],
  #                      dnf: ["libxml2-devel", ...],
  #                      brew: ["libxml2", ...],
  #                      ...
  #
  # @since 0.2.0
  #
  module PackageManager
    include OS
    include OS::Linux
    include Env::Path
    include Sudo

    # The detected package manager.
    #
    # @return [:apt, :dnf, :yum, :zypper, :pacman, :brew, :pkg, :pkg_add, nil]
    attr_reader :package_manager

    #
    # Initializes the command and determines which open command to use.
    #
    # @param [:apt, :dnf, :yum, :zypper, :pacman, :brew, :pkg, :pkg_add, nil] package_manager
    #   The explicit package manager to use. If `nil`, the package manager will
    #   be detected.
    #
    def initialize(package_manager: nil, **kwargs)
      super(**kwargs)

      @package_manager = package_manager || begin
        if macos?
          if    command_installed?('brew') then :brew
          elsif command_installed?('port') then :port
          end
        elsif linux?
          if redhat_linux?
            if    command_installed?('dnf') then :dnf
            elsif command_installed?('yum') then :yum
            end
          elsif debian_linux?
            :apt if command_installed?('apt')
          elsif suse_linux?
            :zypper if command_installed?('zypper')
          elsif arch_linux?
            :pacman if command_installed?('pacman')
          end
        elsif freebsd?
          :pkg if command_installed?('pkg')
        elsif openbsd?
          :pkg_add if command_installed?('pkg_add')
        end
      end
    end

    #
    # Installs the packages using the system's package manager.
    #
    # @param [Array<String>, String] packages
    #   A list of package name(s) to install.
    #
    # @param [Boolean] yes
    #   Assume yes for all user prompts.
    #
    # @param [Array<String>, String] apt
    #   List of `apt` specific package names.
    #
    # @param [Array<String>, String] brew
    #   List of `brew` specific package names.
    #
    # @param [Array<String>, String] dnf
    #   List of `dnf` specific package names.
    #
    # @param [Array<String>, String] pacman
    #   List of `pacman` specific package names.
    #
    # @param [Array<String>, String] pkg
    #   List of `pkg` specific package names.
    #
    # @param [Array<String>, String] pkg_add
    #   List of `pkg_add` specific package names.
    #
    # @param [Array<String>, String] port
    #   List of `port` specific package names.
    #
    # @param [Array<String>, String] yum
    #   List of `yum` specific package names.
    #
    # @param [Array<String>, String] zypper
    #   List of `zypper` specific package names.
    #
    # @return [Boolean, nil]
    #   Specifies whether the packages were successfully installed or not.
    #   If the package manager command could not be determined, `nil` is
    #   returned.
    #
    # @example Install a package
    #   install_packages "nmap", ...
    #
    # @example Install a list of packages per package-manager
    #   install_packages apt: ["libxml2-dev", ...],
    #                    dnf: ["libxml2-devel", ...],
    #                    brew: ["libxml2", ...],
    #                    ...
    #
    def install_packages(*packages, yes: false,
                                    apt: nil,
                                    brew: nil,
                                    dnf: nil,
                                    pacman: nil,
                                    pkg: nil,
                                    pkg_add: nil,
                                    port: nil,
                                    yum: nil,
                                    zypper: nil)
      specific_package_names = case @package_manager
                               when :apt     then apt
                               when :brew    then brew
                               when :dnf     then dnf
                               when :pacman  then pacman
                               when :pkg     then pkg
                               when :pkg_add then pkg_add
                               when :port    then port
                               when :yum     then yum
                               when :zypper  then zypper
                               end
      packages += Array(specific_package_names)

      case @package_manager
      when :apt
        args = []
        args << '-y' if yes

        sudo('apt','install',*args,*packages)
      when :brew
        system('brew','install',*packages)
      when :dnf, :yum
        args = []
        args << '-y' if yes

        sudo(@package_manager.to_s,'install',*args,*packages)
      when :pacman
        missing_packages = `pacman -T #{Shellwords.shelljoin(packages)}`.split

        if missing_packages.empty?
          return true
        end

        sudo('pacman','-S',*missing_packages)
      when :pkg
        args = []
        args << '-y' if yes

        sudo('pkg','install',*args,*packages)
      when :pkg_add
        sudo('pkg_add',*packages)
      when :port
        sudo('port','install',*packages)
      when :zypper
        sudo('zypper','-n','in','-l',*packages)
      end
    end
  end
end
