module CommandKit
  #
  # Provides access to environment variables.
  #
  # ## Examples
  #
  #     class MyCmd
  #       include CommandKit::Env
  #
  #       def main
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
    #
    # Prepends the {Prepend} module.
    #
    # @param [Class] command
    #   The command class including {Env}.
    #
    def self.included(command)
      command.prepend Prepend
    end

    # The environment variables hash.
    #
    # @return [Hash{String => String}]
    attr_reader :env

    #
    # Prepends the {Prepend#initialize #initialize} method.
    #
    module Prepend
      #
      # Initializes {#env}.
      #
      # @param [Hash{String => String}] env
      #   The given environment for the command. Defaults to the global `ENV`.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      def initialize(env: ENV, **kwargs)
        @env = env

        if self.class.instance_method(:initialize).arity == 0
          super()
        else
          super(**kwargs)
        end
      end
    end
  end
end
