# frozen_string_literal: true

require_relative '../options'

module CommandKit
  module Options
    #
    # Defines a `-v`,`--verbose` option that can be specified multiple times to
    # increase the verbosity level.
    #
    # ## Examples
    #
    #     include CommandKit::Options::VerboseLevel
    #
    #     def run(*argv)
    #       # ...
    #       case verbose
    #       when 1
    #         puts "verbose output"
    #       when 2
    #         puts " extra verbose output"
    #       end
    #       # ...
    #     end
    #
    # @since 0.6.0
    #
    module VerboseLevel
      include Options

      #
      # @api private
      #
      module ModuleMethods
        #
        # Defines a `-v, --verbose` option or extends {ModuleMethods}, depending
        # on whether {Options::Verbose} is being included into a class or a
        # module.
        #
        # @param [Class, Module] context
        #   The class or module including {Verbose}.
        #
        def included(context)
          super(context)

          if context.class == Module
            context.extend ModuleMethods
          else
            context.option :verbose, short: '-v', desc: 'Increases the verbosity level' do
              @verbose += 1
            end
          end
        end
      end

      extend ModuleMethods

      # The verbosity level.
      #
      # @return [Integer]
      attr_reader :verbose

      #
      # Initializes the command and sets {#verbose} to 0.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      def initialize(**kwargs)
        super(**kwargs)

        @verbose = 0
      end

      #
      # Determines if verbose mode is enabled.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def verbose? = @verbose > 0
    end
  end
end
