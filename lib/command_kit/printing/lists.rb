# frozen_string_literal: true

module CommandKit
  module Printing
    #
    # @since 0.4.0
    #
    module Lists
      #
      # Prints a bulleted list of items.
      #
      # @param [Array] list
      #   The list of items to print.
      #
      # @param [String] bullet
      #   The bullet character to use for line item.
      #
      # @example
      #   print_list %w[foo bar baz]
      #   # * foo
      #   # * bar
      #   # * baz
      #
      # @example with a custom bullet character:
      #   print_list %w[foo bar baz], bullet: '-'
      #   # - foo
      #   # - bar
      #   # - baz
      #
      # @since 0.4.0
      #
      def print_list(list, bullet: '*')
        list.each do |item|
          puts "#{bullet} #{item}"
        end
      end
    end
  end
end
