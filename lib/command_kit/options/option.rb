require 'command_kit/arguments/argument'

require 'optparse'
require 'date'
require 'time'
require 'uri'
require 'shellwords'

module CommandKit
  module Options
    class Option < Arguments::Argument

      module Name
        #
        # Upcases the option name.
        #
        # @param [Symbol] name
        #   The option name.
        #
        # @return [String]
        #
        def self.upcase(name)
          Arguments::Argument::Name.upcase(name)
        end

        #
        # Replaces all underscores with dashes.
        #
        # @param [Symbol] name
        #   The option name.
        #
        # @return [String]
        #
        def self.dasherize(name)
          name.to_s.tr('_','-')
        end

        #
        # Converts the option name into a long option (ex: `--long-opt`).
        #
        # @param [Symbol] name
        #   The option name.
        #
        # @return [String]
        #
        def self.long_opt(name)
          "--#{dasherize(name)}"
        end
      end

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
        Array      => 'LIST,...',
        Regexp     => '/REGEXP/'
      }

      # @return [String, nil]
      attr_reader :short

      # @return [String]
      attr_reader :long

      # @return [Object, Proc, nil]
      attr_reader :default

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
      # @note `usage` will be assigned a default value based on `type`.
      #
      def initialize(name, type:    nil,
                           short:   nil,
                           long:    self.class.default_long_opt(name),
                           equals:  false,
                           usage:   self.class.default_usage(name,type),
                           default: nil,
                           **kwargs,
                           &block)
        super(name, type: type, usage: usage, **kwargs, &block)

        @short   = short
        @long    = long
        @equals  = equals
        @default = default
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
        Name.long_opt(name)
      end

      #
      # The default usage string (ex: `NUM`) for the given option name and type.
      #
      # @param [Symbol] name
      #
      # @param [Class] type
      #
      # @return [String]
      #
      def self.default_usage(name,type)
        USAGES.fetch(type) { Name.upcase(name) }
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
        [*@short, "#{@long}#{separator}#{super}"]
      end

      #
      # The default value for the option.
      #
      # @return [Object]
      #
      # @note
      #   If the default value responds to the method `#call`, the `#call`
      #   method will be called and it's return value will be returned.
      #
      def default_value
        if @default.respond_to?(:call) then @default.call
        else                                @default.dup
        end
      end

    end
  end
end
