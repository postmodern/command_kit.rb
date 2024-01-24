# frozen_string_literal: true

module CommandKit
  module Commands
    #
    # Represents a registered subcommand.
    #
    # @api private
    #
    class Subcommand

      # The command class.
      #
      # @return [Class]
      attr_reader :command

      # A short summary for the subcommand.
      #
      # @return [String, nil]
      attr_reader :summary

      # Optional alias names for the subcommand.
      #
      # @return [Array<String>]
      attr_reader :aliases

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
      # @param [Array<String>] aliases
      #   Optional alias names for the subcommand.
      #
      def initialize(command, summary: self.class.summary(command),
                              aliases: [])
        @command = command
        @summary = summary
        @aliases = aliases.map(&:to_s)
      end

      #
      # Derives a summary from the command's description.
      #
      # @param [Class] command
      #   The command class.
      #
      # @return [String, nil]
      #   If the command responds to a `#description` method, the first sentence
      #   of the description will be returned. Otherwise `nil` is returned.
      #
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
