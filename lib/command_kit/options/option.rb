require 'command_kit/options/option_value'

require 'optparse'
require 'date'
require 'time'
require 'uri'
require 'shellwords'

module CommandKit
  module Options
    #
    # Represents a defined option.
    #
    class Option

      # @return [Symbol]
      attr_reader :name

      # @return [String, nil]
      attr_reader :short

      # @return [String]
      attr_reader :long

      # @return [OptionValue, nil]
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
      # @param [Hash{Symbol => Object}, nil] value
      #   Keyword arguments for {OptionValue#initialize}, or `nil` if the option
      #   has no additional value.
      #
      # @option value [Class, Hash, Array, Regexp] type
      #
      # @option value [String, nil] usage
      #
      # @param [String] desc
      #
      # @yield [(value)]
      #
      # @yieldparam [Object, nil] value
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
      # @return ['=', ' ', nil]
      #
      def separator
        if @value
          if equals? then '='
          else            ' '
          end
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
      # Determines if the option has a value.
      #
      # @return [Boolean]
      #
      def value?
        !@value.nil?
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
      #   If {#default_value} returns a value, the description will contain the
      #   `Default:` value the option will be initialized with.
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
