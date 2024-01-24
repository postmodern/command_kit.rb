# frozen_string_literal: true

module CommandKit
  #
  # Provides access to environment variables.
  #
  # ## Examples
  #
  #     class MyCmd
  #       include CommandKit::Env
  #
  #       def run
  #         home = env['HOME']
  #         # ...
  #       end
  #     end
  #
  # ## Testing
  #
  # Can be initialized with a custom `env` hash for testing purposes.
  #
  #     MyCmd.new(env: {...})
  #
  module Env
    # The environment variables hash.
    #
    # @return [Hash{String => String}]
    #
    # @api public
    attr_reader :env

    #
    # Initializes {#env}.
    #
    # @param [Hash{String => String}] env
    #   The given environment for the command. Defaults to the global `ENV`.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @api public
    #
    def initialize(env: ENV, **kwargs)
      @env = env

      super(**kwargs)
    end
  end
end
