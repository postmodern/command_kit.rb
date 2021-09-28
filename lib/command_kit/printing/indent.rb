module CommandKit
  module Printing
    #
    # Adds the ability to automatically indent all calls to `puts`.
    #
    # ## Examples
    #
    #     include Printing::Indent
    #     
    #     def main
    #       puts "regular output:"
    #     
    #       indent(4) do
    #         puts "indented output"
    #         puts "..."
    #       end
    #     
    #       puts "back to regular output"
    #     end
    #
    module Indent
      #
      # Initializes the indentation level to zero.
      #
      def initialize(**kwargs)
        @indent = 0

        super(**kwargs)
      end

      #
      # Increases the indentation level by two, yields, then restores the
      # indentation level.
      #
      # @param [Integer] n
      #   How much to increase the indentation level by.
      #
      # @yield []
      #   The given block will be called after the indentation level has been
      #   increased.
      #
      # @return [Integer]
      #   If no block is given, the indentation level will be returned.
      #
      # @example
      #   puts "values:"
      #   indent do
      #     values.each do |key,value|
      #       puts "#{key}: #{value}"
      #     end
      #   end
      #
      # @example
      #   puts "Code:"
      #   puts
      #   puts "```"
      #   indent(4) do
      #     code.each_line do |line|
      #       puts line
      #     end
      #   end
      #   puts "```"
      #
      # @api public
      #
      def indent(n=2)
        if block_given?
          original_indent = @indent

          begin
            @indent += n
            yield
          ensure
            @indent = original_indent
          end
        else
          @indent
        end
      end

      #
      # Indents and prints the lines to stdout.
      #
      # @param [Array<String>] lines
      #   The lines to indent and print.
      #
      # @api public
      #
      def puts(*lines)
        if (@indent > 0 && !lines.empty?)
          padding = " " * @indent

          super(*lines.map { |line| "#{padding}#{line}" })
        else
          super(*lines)
        end
      end

    end
  end
end
