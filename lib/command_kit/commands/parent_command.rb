module CommandKit
  module Commands
    module ParentCommand

      # The parent command instance.
      #
      # @return [Object<Commands>]
      attr_reader :parent_command

      #
      # Initializes the command and sets {#parent_command}.
      #
      def initialize(parent_command: , **kwargs)
        @parent_command = parent_command

        super(**kwargs)
      end

    end
  end
end
