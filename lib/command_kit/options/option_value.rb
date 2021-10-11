# frozen_string_literal: true

require 'command_kit/arguments/argument_value'
require 'command_kit/inflector'

require 'optparse'
require 'date'
require 'time'
require 'uri'
require 'shellwords'

module CommandKit
  module Options
    #
    # Represents an additional argument associated with an option flag.
    #
    # @api private
    #
    class OptionValue < Arguments::ArgumentValue

      # Maps OptionParser types to USAGE strings.
      USAGES = {
        # NOTE: NilClass and Object are intentionally omitted
        Date       => 'DATE',
        DateTime   => 'DATE_TIME',
        Time       => 'TIME',
        URI        => 'URI',
        Shellwords => 'STR',
        String     => 'STR',
        Integer    => 'INT',
        Float      => 'DEC',
        Numeric    => 'NUM',
        OptionParser::DecimalInteger => 'INT',
        OptionParser::OctalInteger   => 'OCT',
        OptionParser::DecimalNumeric => 'NUM|DEC',
        TrueClass  => 'BOOL',
        FalseClass => 'BOOL',
        Array      => 'LIST[,...]',
        Regexp     => '/REGEXP/'
      }

      # The desired type of the argument value.
      #
      # @return [Class, Hash, Array, Regexp]
      attr_reader :type

      # The default parsed value for the argument value.
      #
      # @return [Object, Proc, nil]
      attr_reader :default

      #
      # Initializes the option value.
      #
      # @param [Class, Hash, Array, Regexp] type
      #   The type of the option value.
      #
      # @param [Object, Proc, nil] default
      #   The default parsed value for the option value.
      #
      # @param [String, nil] usage
      #   The optional usage string for the option value.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @option kwargs [Boolean] required
      #   Specifies whether the option value is required or optional.
      #
      def initialize(type:    String,
                     default: nil,
                     usage:   self.class.default_usage(type),
                     **kwargs)
        super(usage: usage, **kwargs)

        @type    = type
        @default = default
      end

      #
      # Returns the default option value usage for the given type.
      #
      # @param [Class, Hash, Array, Regexp] type
      #   The option value type.
      #
      # @return [String, nil]
      #   A default usage string based on the option value type.
      #
      # @raise [TypeError]
      #   The given type was not a Class, Hash, Array, or Regexp.
      #
      def self.default_usage(type)
        USAGES.fetch(type) do
          case type
          when Class  then Inflector.underscore(type.name).upcase
          when Hash   then type.keys.join('|')
          when Array  then type.join('|')
          when Regexp then type.source
          else
            raise(TypeError,"unsupported option type: #{type.inspect}")
          end
        end
      end

      #
      # The usage string for the argument.
      #
      # @return [String, nil]
      #
      def usage
        string = @usage
        string = "[#{string}]" if optional?
        string
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
