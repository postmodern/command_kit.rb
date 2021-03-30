module CommandKit
  module Commands
    class Subcommand

      # The command class.
      #
      # @return [Class]
      attr_reader :command

      # A short summary for the subcommand.
      #
      # @return [String, nil]
      attr_reader :summary

      #
      # Initializes the subcommand.
      #
      # @param [Class] command
      #   The command class.
      #
      # @param [String, nil] summary
      #   A short summary for the subcommand. Defaults to the first sentence
      #   of the command.
      #
      def initialize(command, summary: self.class.summary(command))
        @command = command
        @summary = summary
      end

      def self.summary(command)
        if command.respond_to?(:description)
          if (desc = command.description)
            # extract the first sentence
            desc[/^[^\.]+/]
          end
        end
      end

    end
  end
end
