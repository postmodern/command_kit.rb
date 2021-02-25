# frozen_string_literal: true

require 'command_kit/env'

module CommandKit
  module Env
    #
    # Provides access to the `HOME` environment variable.
    #
    module Home
      #
      # Includes {Env} and extends {ClassMethods}.
      #
      # @param [Class] command
      #   The command class which is including {Home}.
      #
      def self.included(command)
        command.include Env
        command.extend ClassMethods
      end

      #
      # Class-level methods.
      #
      module ClassMethods
        #
        # The default home directory.
        #
        # @return [String]
        #
        def home_dir
          Gem.user_home
        end
      end

      # The home directory.
      #
      # @return [String]
      attr_reader :home_dir

      #
      # Initializes {#home_dir} to either `env['HOME']` or
      # {ClassMethods#home_dir self.class.home_dir}.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      def initialize(**kwargs)
        @home_dir = env.fetch('HOME') { self.class.home_dir }

        super(**kwargs)
      end
    end
  end
end
