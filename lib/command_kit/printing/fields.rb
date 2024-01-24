# frozen_string_literal: true

require_relative 'indent'

module CommandKit
  module Printing
    #
    # Supports printing aligned key/value fields.
    #
    # @since 0.4.0
    #
    module Fields
      include Indent

      #
      # Prints a Hash as left-justified `:` separated fields.
      #
      # @param [Hash, Array<(Object, Object)>] fields
      #   The fields to print.
      #
      # @example
      #   print_fields('Name' => 'foo', 'Version' => '0.1.0')
      #   # Name:    foo
      #   # Version: 0.1.0
      #
      # @api public
      #
      def print_fields(fields)
        max_length = 0

        fields = fields.map { |name,value|
          name       = name.to_s
          value      = value.to_s
          max_length = name.length if name.length > max_length

          [name, value]
        }

        fields.each do |name,value|
          first_line, *rest = value.to_s.lines(chomp: true)

          # print the first line with the header
          header = "#{name}:".ljust(max_length + 1)
          puts "#{header} #{first_line}"

          # indent and print the rest of the lines
          indent(max_length + 2) do
            rest.each do |line|
              puts line
            end
          end
        end

        return nil
      end
    end
  end
end
