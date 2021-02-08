module CommandKit
  module Arguments
    #
    # Represents an individual argument value.
    #
    class ArgumentValue

      # The desired type of the argument value.
      #
      # @return [Class, Hash, Array, Regexp, nil]
      attr_reader :type

      # The default parsed value for the argument value.
      #
      # @return [Object, Proc, nil]
      attr_reader :default

      # Specifies whether the argument value is required or optional.
      #
      # @return [Boolean]
      attr_reader :required

      # The usage string to describe the argument value.
      #
      # @return [String]
      attr_reader :usage

      #
      # Initializes the argument value.
      #
      # @param [Class, Hash, Array, Regexp] type
      #   The type of the argument value.
      #
      # @param [Boolean] required
      #   Specifies whether the argument value is required or optional.
      #
      # @param [String] usage
      #   The usage string to represent the argument value.
      #
      # @param [Object, Proc, nil] default
      #   The default parsed value for the argument value.
      #
      def initialize(type: nil, required: true, default: nil, usage: )
        @type     = type
        @required = required
        @default  = default
        @usage    = usage
      end

      #
      # Determines if the argument is required or not.
      #
      # @return [Boolean]
      #
      def required?
        @required
      end

      #
      # Determines whether the argument can be omitted.
      #
      # @return [Boolean]
      #
      def optional?
        !@required
      end

      #
      # Returns a new default value.
      #
      # @return [Object]
      #
      def default_value
        if @default.respond_to?(:call) then @default.call
        else                                @default.dup
        end
      end

    end
  end
end
