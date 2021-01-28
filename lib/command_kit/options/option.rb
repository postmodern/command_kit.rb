require 'command_kit/options/option_value'

require 'optparse'
require 'date'
require 'time'
require 'uri'
require 'shellwords'

module CommandKit
  module Options
    class Option

      # @return [Symbol]
      attr_reader :name

      # @return [String, nil]
      attr_reader :short

      # @return [String]
      attr_reader :long

      # @return [Value, nil]
      attr_reader :value

      # @return [String]
      attr_reader :desc

      # @return [Proc, nil]
      attr_reader :block

      #
      # Initializes the option.
      #
      # @param [Symbol] name
      #
      # @param [String, nil] short
      #
      # @param [String, nil] long
      #
      # @param [Boolean] equals
      #
      # @param [Proc, Object, nil] default
      #   The default value for the option.
      #
      def initialize(name, short:   nil,
                           long:    self.class.default_long_opt(name),
                           equals:  false,
                           value:   nil,
                           desc:    ,
                           &block)
        @name    = name
        @short   = short
        @long    = long
        @equals  = equals
        @value   = OptionValue.new(**value) if value
        @desc    = desc
        @block   = block
      end

      #
      # The default long option (ex: `--long-opt`) for the given option name
      # (ex: `:long_opt`).
      #
      # @param [Symbol] name
      #
      # @return [String]
      #
      def self.default_long_opt(name)
        "--#{Inflector.dasherize(name)}"
      end

      #
      # Specifies if the option is of the form `--opt=VALUE`.
      #
      # @return [Boolean]
      #
      def equals?
        @equals
      end

      #
      # The separator characer between the option and option value.
      #
      # @return ['=', ' ']
      #
      def separator
        if equals? then '='
        else            ' '
        end
      end

      #
      # Usage strings for the option.
      #
      # @return [Array<String>]
      #   The usage strings.
      #
      def usage
        [*@short, "#{@long}#{separator}#{@value && @value.usage}"]
      end

      #
      # The option value's type.
      #
      # @return [Class, nil]
      #
      # @see OptionValue#type
      #
      def type
        @value && @value.type
      end

      #
      # The option value's default value.
      #
      # @return [Object, nil]
      #
      # @see OptionValue#default_value
      #
      def default_value
        @value && @value.default_value
      end

      #
      # The option description.
      #
      # @return [String]
      #
      # @note
      #   If {#default} is set, the description will contain the `Default:`
      #   value.
      #
      def desc
        if (value = default_value)
          "#{@desc} (Default: #{value})"
        else
          @desc
        end
      end

    end
  end
end
