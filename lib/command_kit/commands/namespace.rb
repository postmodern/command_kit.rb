require 'command_kit/inflector'

module CommandKit
  module Commands
    #
    # Provides Hash-like access to the classes defined within a module or a
    # class.
    #
    class Namespace

      # The namespace module or class.
      #
      # @return [Module, Class]
      attr_reader :namespace

      # An explicit mapping of under_scored command names to CamelCase
      # command class names.
      # 
      # @return [Hash{String => String}]
      attr_reader :const_map

      #
      # Initializes the namespace.
      #
      # @param [Module, Class] namespace
      #   The namespace module or class.
      #
      # @param [Hash{String => String}] const_map
      #   An optional explicit mapping of under_scored command names to
      #   CamelCase command classes.
      #
      def initialize(namespace, const_map: {})
        @namespace = namespace

        @const_map = const_map.dup
      end

      #
      # Converts an under_scored command name to a CamelCased constant name.
      #
      # @param [String, Symbol] name
      #   The under_scored command name.
      #
      # @return [String]
      #   The CamelCased constant name.
      #
      # @group Namespace methods
      #
      def const_for(name)
        @const_map.fetch(name.to_s) { Inflector.camelize(name) }
      end

      #
      # Gets a constant from the namespace.
      #
      # @param [String, Symbol] name
      #   The constant name.
      #
      # @return [Class, Module]
      #   The constant value.
      #
      # @raise [NameError]
      #   The constant could not be found in the namespace.
      #
      # @group Namespace methods
      #
      def const_get(name)
        @namespace.const_get(name,false)
      end

      #
      # Determines if a constant exists within the namespace.
      #
      # @param [String, Symbol] name
      #   The constant name.
      #
      # @return [Boolean]
      #
      # @group Namespace methods
      #
      def const_defined?(name)
        @namespace.const_defined?(name,false)
      end

      #
      # Returns all constant names within the namespace.
      #
      # @return [Array<Symbol>]
      #   The constant names.
      #
      # @group Namespace methods
      #
      def constants
        @namespace.constants(false)
      end

      #
      # Determines if the given key String maps to a constant defined in the
      # namespace.
      #
      # @param [String] key
      #   The key String to check for.
      #
      # @return [Boolean]
      #
      # @group Hash methods
      #
      def has_key?(key)
        const_defined?(const_for(key))
      end

      #
      # @see has_key?
      #
      def key?(key)
        has_key?(key)
      end

      #
      # @see has_key?
      #
      def include?(key)
        has_key?(key)
      end

      #
      # @see has_key?
      #
      def member?(key)
        has_key?(key)
      end

      #
      # All command names within the namespace.
      #
      # @return [Array<String>]
      #   The key Strings representing the constants defined in the namespace.
      #
      # @group Hash methods
      #
      def keys
        command_names = @const_map.invert

        constants.map do |name|
          command_names.fetch(name.to_s) { Inflector.underscore(name) }
        end
      end

      #
      # Enumerates over the command names within the namespace.
      #
      # @yield [key]
      #   If a block is given, it will be passed each key for each constant
      #   defined in the namespace.
      #
      # @yieldparam [String] key
      #   A key String representing a constant defined in the namespace.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @group Hash methods
      #
      def each_key(&block)
        keys.each(&block)
      end

      #
      # Fetches a command class from the namespace with the given command name.
      #
      # @param [String] name
      #   The under_scored command name for the constant.
      #
      # @return [Class, Module, nil]
      #
      # @group Hash methods
      #
      def [](name)
        const = const_for(name)

        const_get(const) if const_defined?(const)
      end

      #
      # Fetches a constant from the namespace using it's under_scored command
      # name.
      #
      # @param [String] name
      #   The under_scored command name for the constant.
      #
      # @param [Object] default
      #   The optional value to return if the constant cannot be found.
      #
      # @yield [(key)]
      #   If a block is given, it will be called if the constant cannot be
      #   found.
      #
      # @yieldparam [String] key
      #   A key String representing a constant defined in the namespace.
      #
      # @return [Class, Module, nil]
      #   The class or module.
      #
      # @group Hash methods
      #
      def fetch(name,*default,&block)
        self[name] || if default.length == 1
                        default.first
                      elsif block
                        if block.arity == 0 then block.call()
                        else                     block.call(name)
                        end
                      else
                        raise(KeyError,"could not find command #{name.inspect} in #{@path.inspect}")
                      end
      end

    end
  end
end
