# frozen_string_literal: true

require_relative 'indent'

module CommandKit
  module Printing
    #
    # Methods for printing lists.
    #
    # ## Examples
    #
    #     include Printing::Lists
    #     
    #     def main
    #       print_list %w[foo bar baz]
    #       # * foo
    #       # * bar
    #       # * baz
    #
    #       list = ['item 1', 'item 2', ['sub-item 1', 'sub-item 2']]
    #       print_list(list)
    #       # * item 1
    #       # * item 2
    #       #   * sub-item 1
    #       #   * sub-item 2
    #
    #       print_list %w[foo bar baz], bullet: '-'
    #       # - foo
    #       # - bar
    #       # - baz
    #     end
    #
    # @since 0.4.0
    #
    module Lists
      include Indent

      #
      # Prints a bulleted list of items.
      #
      # @param [Array<#to_s, Array>] list
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
      # @example print a nested list:
      #   list = ['item 1', 'item 2', ['sub-item 1', 'sub-item 2']]
      #   print_list(list)
      #   # * item 1
      #   # * item 2
      #   #   * sub-item 1
      #   #   * sub-item 2
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
          case item
          when Array
            indent { print_list(item, bullet: bullet) }
          else
            first_line, *rest = item.to_s.lines(chomp: true)

            # print the bullet only on the first list
            puts "#{bullet} #{first_line}"

            # indent the remaining lines
            indent(bullet.length + 1) do
              rest.each do |line|
                puts line
              end
            end
          end
        end
      end
    end
  end
end
