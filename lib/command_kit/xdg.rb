require 'command_kit/command_name'
require 'command_kit/env/home'

module CommandKit
  #
  # Provides access to [XDG directories].
  #
  # * `~/.config`
  # * `~/.local/share`
  # * `~/.cache`
  #
  # [XDG directories]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
  #
  module XDG
    #
    # Includes {CommandName}, extends {ClassMethods}, includes {Env::Home}, and
    # prepends {Prepend}.
    #
    # @param [Class] command
    #   The command class which is including {XDG}.
    #
    def self.included(command)
      command.include CommandName
      command.extend ClassMethods
      command.include Env::Home
      command.prepend Prepend
    end

    module ClassMethods
      #
      # Gets or sets the XDG sub-directory name used by the command.
      #
      # @param [#to_s, nil] new_namespace
      #   If a new_namespace argument is given, it will set the class'es
      #   {#xdg_namespace} string.
      #
      # @return [String]
      #   The class'es or superclass'es {#xdg_namespace}. Defaults to
      #   {CommandName::ClassMethods#command_name} if no {#xdg_namespace} has
      #   been defined.
      #
      def xdg_namespace(new_namespace=nil)
        if new_namespace
          @xdg_namespace = new_namespace.to_s
        else
          @xdg_namespace || (superclass.xdg_namespace if superclass.kind_of?(ClassMethods)) || command_name
        end
      end
    end

    #
    # Methods that are prepended to the including class.
    #
    module Prepend
      #
      # Initializes {#config_dir}, {#local_share_dir}, and {#cache_dir}.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @note
      #   If the `$XDG_CONFIG_HOME` env variable is set, then {#config_dir} will
      #   be initialized to effectively `$XDG_CONFIG_HOME/<xdg_namespace>`.
      #   Otherwise {#config_dir} will be initialized to
      #   `~/.config/<xdg_namespace>`.
      #
      # @note
      #   If the `$XDG_DATA_HOME` env variable is set, then {#local_share_dir}
      #   will be initialized to effectively `$XDG_DATA_HOME/<xdg_namespace>`.
      #   Otherwise {#local_share_dir} will be initialized to
      #   `~/.local/share/<xdg_namespace>`.
      #
      # @note
      #   If the `$XDG_CACHE_HOME` env variable is set, then {#cache_dir} will
      #   be initialized to effectively `$XDG_CACHE_HOME/<xdg_namespace>`.
      #   Otherwise {#cache_dir} will be initialized to
      #   `~/.cache/<xdg_namespace>`.
      #
      def initialize(**kwargs)
        super(**kwargs)

        @config_dir = File.join(
          env.fetch('XDG_CONFIG_HOME') {
            File.join(home_dir,'.config')
          }, xdg_namespace
        )

        @local_share_dir = File.join(
          env.fetch('XDG_DATA_HOME') {
            File.join(home_dir,'.local','share')
          }, xdg_namespace
        )

        @cache_dir = File.join(
          env.fetch('XDG_CACHE_HOME') {
            File.join(home_dir,'.cache')
          }, xdg_namespace
        )
      end
    end

    # The `~/.config/` directory.
    #
    # @return [String]
    attr_reader :config_dir

    # The `~/.local/share/` directory.
    #
    # @return [String]
    attr_reader :local_share_dir

    # The `~/.cache/` directory.
    #
    # @return [String]
    attr_reader :cache_dir

    #
    # @see ClassMethods#xdg_namespace
    #
    def xdg_namespace
      self.class.xdg_namespace
    end
  end
end
