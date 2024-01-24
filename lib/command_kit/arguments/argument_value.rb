# frozen_string_literal: true
module CommandKit
  module Arguments
    #
    # Represents an individual argument value.
    #
    # @api private
    #
    class ArgumentValue

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
      # @param [Boolean] required
      #   Specifies whether the argument value is required or optional.
      #
      # @param [String] usage
      #   The usage string to represent the argument value.
      #
      def initialize(required: true, usage: )
        @required = required
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

    end
  end
end
