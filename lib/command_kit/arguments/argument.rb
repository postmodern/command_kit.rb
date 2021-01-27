module CommandKit
  module Arguments
    class Argument

      module Name
        #
        # Upcases an argument name.
        #
        # @param [Symbol] name
        #
        # @return [String]
        #
        def self.upcase(name)
          name.to_s.upcase
        end
      end

      # @return [Symbol]
      attr_reader :name

      # @return [Class, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :desc

      # @return [String]
      attr_reader :usage

      # @return [Object, Proc, nil]
      attr_reader :default

      # @return [Regexp, nil]
      attr_reader :pattern

      # @return [Proc, nil]
      attr_reader :parser

      # @return [Proc, nil]
      attr_reader :block

      #
      # Initializes the argument.
      #
      # @param [Symbol] name
      #
      # @param [Class] type
      #
      # @param [String] desc
      #
      # @param [String, nil] usage
      #
      # @param [Object, Proc, nil] default
      #
      # @param [Boolean] required
      #
      # @note `usage` will be assigned a default value based on `type` and
      # `name`.
      #
      def initialize(name, type:     String,
                           desc:     ,
                           usage:    self.class.uage(name),
                           default:  nil,
                           required: false,
                           &block)
        @name = name
        @type = type
        @desc = desc
        @usage = usage
        @default = default
        @required = required

        @pattern, @parser = self.class.optparse(@type)
      end

      #
      # The default usage string (ex: `NUM`) for the given argument name
      # (ex: `:input`).
      #
      # @param [Symbol] name
      #
      # @return [String]
      #
      def self.default_usage(name)
        Name.upcase(name)
      end

      #
      # @return [(Regexp, Proc), nil]
      #
      def self.optparse(type)
        OptionParser::DefaultList.search(:atype,type)
      end

      #
      # Generates a default usage string for an argument name.
      #
      # @param [Symbol] name
      #   The given argument name.
      #
      # @return [String]
      #   The default usage string.
      #
      def self.default_usage(name)
        if type == String
          Name.upcase(name)
        else
          USAGES[type]
        end
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
      # The usage string for the argument.
      #
      # @return [String, nil]
      #
      def usage
        if required? then @usage
        elsif @usage then "[#{@usage}]"
        end
      end

      #
      # Parses the given argument.
      #
      # @param [Stirng, nil] arg
      #   The given argument.
      #
      # @return [Object]
      #   The parsed argument.
      #
      def parse(arg)
        if @parser
          arg = @parser.call(arg)
        end

        if @block
          arg = @block.call(arg)
        end

        return arg
      end

    end
  end
end
