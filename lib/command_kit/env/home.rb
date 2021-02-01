# frozen_string_literal: true

require 'command_kit/env'

module CommandKit
  module Env
    #
    # Provides access to the `HOME` environment variable.
    #
    module Home
      def self.included(command)
        command.include Env
        command.extend ClassMethods
      end

      #
      # Class-level methods.
      #
      module ClassMethods
        #
        # Home directory.
        #
        # @return [String]
        #
        def home
          Gem.user_home
        end
      end

      #
      # The value of the `env['HOME']` variable or {ClassMethods#home .home}.
      #
      # @return [String]
      #
      def home
        env.fetch('HOME') { self.class.home }
      end
    end
  end
end
