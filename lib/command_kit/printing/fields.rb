module CommandKit
  module Printing
    #
    # Supports printing aligned key/value fields.
    #
    # @since 0.4.0
    #
    module Fields
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

        max_length += 1

        fields.each do |name,value|
          header = "#{name}:".ljust(max_length)

          puts "#{header} #{value}"
        end

        return nil
      end
    end
  end
end
