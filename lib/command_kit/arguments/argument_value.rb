module CommandKit
  module Arguments
    #
    # Represents an individual argument value.
    #
    class ArgumentValue

      # @return [Class, Hash, Array, Regexp, nil]
      attr_reader :type

      # @return [Object, Proc, nil]
      attr_reader :default

      # @return [Boolean]
      attr_reader :required

      #
      # Initializes the argument value.
      #
      # @param [Class, Hash, Array, Regexp] type
      #
      # @param [Boolean] required
      #
      # @param [String] usage
      #
      # @param [Object, Proc, nil] default
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
