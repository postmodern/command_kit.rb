# frozen_string_literal: true

require 'command_kit/env'

module CommandKit
  module Env
    #
    # Provides access to the `HOME` environment variable.
    #
    module Home
      #
      # Includes {Env}, extends {ClassMethods}, and prepends {Prepend}.
      #
      # @param [Class] command
      #   The command class which is including {Home}.
      #
      def self.included(command)
        command.include Env
        command.extend ClassMethods
        command.prepend Prepend
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

      #
      # Methods that are prepended to the including class.
      #
      module Prepend
        #
        # Initializes {#home_dir} to either `env['HOME']` or
        # {ClassMethods#home_dir self.class.home_dir}.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @home_dir = env.fetch('HOME') { self.class.home_dir }
        end
      end

      # The home directory.
      #
      # @return [String]
      attr_reader :home_dir
    end
  end
end
