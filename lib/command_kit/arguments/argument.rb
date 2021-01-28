require 'command_kit/arguments/argument_value'

module CommandKit
  module Arguments
    class Argument < ArgumentValue

      # @return [Symbol]
      attr_reader :name

      # @return [String, nil]
      attr_reader :desc

      # @return [Regexp, nil]
      attr_reader :pattern

      # @return [Proc, nil]
      attr_reader :parser

      # @return [Proc, nil]
      attr_reader :block

      #
      # Initializes the argument.
      #
      # @param [Symbol] name
      #
      # @param [Class] type
      #
      # @param [String] desc
      #
      # @param [String, nil] usage
      #
      # @param [Object, Proc, nil] default
      #
      # @param [Boolean] required
      #
      # @note `usage` will be assigned a default value based on `type` and
      # `name`.
      #
      def initialize(name, type:     String,
                           desc:     ,
                           usage:    name.upcase,
                           default:  nil,
                           required: false,
                           &block)
        @name = name
        @desc = desc

        super(
          type:     type,
          usage:    usage,
          default:  default,
          required: required
        )

        @pattern, @parser = self.class.optparse(@type)
        @block = block
      end

      #
      # @return [(Regexp, Proc), nil]
      #
      def self.optparse(type)
        OptionParser::DefaultList.search(:atype,type)
      end

      #
      # Parses the given argument.
      #
      # @param [Stirng, nil] arg
      #   The given argument.
      #
      # @return [Object]
      #   The parsed argument.
      #
      def parse(arg)
        if @parser
          arg = @parser.call(arg)
        end

        if @block
          arg = @block.call(arg)
        end

        return arg
      end

    end
  end
end
