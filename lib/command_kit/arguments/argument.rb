require 'command_kit/arguments/argument_value'

module CommandKit
  module Arguments
    #
    # Represents a defined argument.
    #
    class Argument < ArgumentValue

      # The argument's name.
      #
      # @return [Symbol]
      attr_reader :name

      # The argument's description.
      #
      # @return [String]
      attr_reader :desc

      # The argument's pattern.
      #
      # @note Not currently used.
      # @return [Regexp, nil]
      attr_reader :pattern

      # The argument's parser.
      #
      # @note Not currently used.
      # @return [Proc, nil]
      attr_reader :parser

      # The argument's optional custom parsing logic.
      #
      # @note Not currently used.
      # @return [Proc, nil]
      attr_reader :block

      #
      # Initializes the argument.
      #
      # @param [Symbol] name
      #   The name of the argument.
      #
      # @param [Class, Hash, Array, Regexp] type
      #   The type of the argument. Note: not currently used.
      #
      # @param [String, nil] usage
      #   The usage string for the argument. Defaults to the argument's name.
      #
      # @param [Object, Proc, nil] default
      #   The default value or proc for the argument.
      #
      # @param [Boolean] required
      #   Specifies whether the argument is required or optional.
      #
      # @param [Boolean] repeats
      #   Specifies whether the argument can be repeated multiple times.
      #
      # @param [String] desc
      #   The description for the argument.
      #
      # @yield [(value)]
      #   If a block is given, it will be used to parse the argument's value.
      #   Note: not currently used.
      #
      # @yieldparam [Object, nil] value
      #
      def initialize(name, type:     String,
                           usage:    name.to_s.upcase,
                           default:  nil,
                           required: true,
                           repeats:  false,
                           desc:     ,
                           &block)
        super(
          type:     type,
          usage:    usage,
          default:  default,
          required: required
        )

        @name    = name
        @repeats = repeats
        @desc    = desc

        @pattern, @parser = self.class.parser(@type)

        @block = block
      end

      #
      # Looks up the option parser for the given `OptionParser` type.
      #
      # @param [Class] type
      #   The `OptionParser` type class.
      #
      # @return [(Regexp, Proc), nil]
      #   The matching pattern and converter proc.
      #
      def self.parser(type)
        OptionParser::DefaultList.search(:atype,type)
      end

      #
      # Specifies whether the argument can be repeated repeat times.
      #
      # @return [Boolean]
      #
      def repeats?
        @repeats
      end

      #
      # The usage string for the argument.
      #
      # @return [String]
      #
      def usage
        string = @usage
        string = "#{string} ..." if repeats?
        string = "[#{string}]" if optional?
        string
      end

    end
  end
end
