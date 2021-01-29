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
    class OptionValue < Arguments::ArgumentValue

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

      #
      # Initializes the option value.
      #
      # @param [Class, Hash, Array, Regexp] type
      #
      # @param [String, nil] usage
      #
      # @param [Hash{Symbol => Object}] kwargs
      #
      # @yield [(value)]
      #
      # @yieldparam [Object, nil] value
      #
      def initialize(type: String,
                     usage: self.class.default_usage(type),
                     **kwargs, &block)
        super(type: type, usage: usage, **kwargs, &block)
      end

      #
      # Returns the default option value usage for the given type.
      #
      # @param [Class, Hash, Array, Regexp] type
      #
      # @return [String, nil]
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

    end
  end
end
