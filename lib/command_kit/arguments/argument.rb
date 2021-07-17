require 'command_kit/arguments/argument_value'

module CommandKit
  module Arguments
    #
    # Represents a defined argument.
    #
    # @api private
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

      #
      # Initializes the argument.
      #
      # @param [Symbol] name
      #   The name of the argument.
      #
      # @param [String, nil] usage
      #   The usage string for the argument. Defaults to the argument's name.
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
      def initialize(name, usage:    name.to_s.upcase,
                           required: true,
                           repeats:  false,
                           desc:     )
        super(
          usage:    usage,
          required: required
        )

        @name    = name
        @repeats = repeats
        @desc    = desc
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
