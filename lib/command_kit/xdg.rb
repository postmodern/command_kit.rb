require 'command_kit/env/home'

module CommandKit
  module XDG
    #
    # Includes {Env::Home} and prepends {Prepend}.
    #
    # @param [Class] command
    #   The command class which is including {XDG}.
    #
    def self.included(command)
      command.include Env::Home
      command.prepend Prepend
    end

    module ClassMethods
      def xdg_dir(new_dir=nil)
        if new_dir
          @xdg_dir = new_dir
        else
          @xdg_dir || (superclass.xdg_dir if superclass.kind_of?(ClassMethods) || program_name)
        end
      end
    end

    #
    # Methods that are prepended to the including class.
    #
    module Prepend
      #
      # Initializes {#config_dir}, {#local_share_dir}, and {#cache_dir},
      # based on {Env::Home#home_dir #home_dir}.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      def initialize(**kwargs)
        super(**kwargs)

        @config_dir = env.fetch('XDG_CONFIG_HOME') do
          File.join(home_dir,'.config')
        end

        @local_share_dir = env.fetch('XDG_DATA_HOME') do
          File.join(home_dir,'.local','share')
        end

        @cache_dir = env.fetch('XDG_CACHE_HOME') do
          File.join(home_dir,'.cache')
        end
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
  end
end
