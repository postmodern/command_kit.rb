require 'command_kit/arguments/argument_value'
require 'command_kit/inflector'

require 'optparse'
require 'date'
require 'time'
require 'uri'
require 'shellwords'

module CommandKit
  module Options
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
        Array      => 'LIST,...',
        Regexp     => '/REGEXP/'
      }

      #
      # Initializes the option value.
      #
      def initialize(type: nil,
                     usage: self.class.default_usage(type),
                     **kwargs, &block)
        super(type: type, usage: usage, **kwargs, &block)
      end

      def self.default_usage(type)
        if !type.nil?
          USAGES.fetch(type) do
            Inflector.underscore(type.name).upcase
          end
        end
      end

    end
  end
end
