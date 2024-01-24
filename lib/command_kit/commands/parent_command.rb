# frozen_string_literal: true

module CommandKit
  module Commands
    #
    # Allows a command to be aware of it's parent command.
    #
    module ParentCommand

      # The parent command instance.
      #
      # @return [Object<Commands>]
      #
      # @api semipublic
      attr_reader :parent_command

      #
      # Initializes the command and sets {#parent_command}.
      #
      # @api public
      #
      def initialize(parent_command: , **kwargs)
        @parent_command = parent_command

        super(**kwargs)
      end

    end
  end
end
