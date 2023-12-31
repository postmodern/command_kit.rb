# frozen_string_literal: true

require 'command_kit/env'

module CommandKit
  module Env
    #
    # Methods related to the `PREFIX` environment variable.
    #
    # ## Environment Variables
    #
    # * `PREFIX` - The optional root prefix of the file-system.
    #
    # @since 0.5.0
    #
    module Prefix
      include Env

      # The root of the file-system.
      #
      # @return [String]
      #   The `PREFIX` environment variable, or `/` if no `PREFIX` environment
      #   variable is given.
      attr_reader :root

      #
      # Initialize {#root} based on the `PREFIX` environment
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @api public
      #
      def initialize(**kwargs)
        super(**kwargs)

        @root = env.fetch('PREFIX','/')
      end
    end
  end
end
