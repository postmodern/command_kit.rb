# frozen_string_literal: true
require_relative '../options'

module CommandKit
  module Options
    #
    # Defines a `-v`,`--verbose` option.
    #
    # ## Examples
    #
    #     include CommandKit::Options::Verbose
    #
    #     def run(*argv)
    #       # ...
    #       puts "verbose output" if verbose?
    #       # ...
    #     end
    #
    module Verbose
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
            context.option :verbose, short: '-v', desc: 'Enables verbose output' do
              @verbose = true
            end
          end
        end
      end

      extend ModuleMethods

      #
      # Determines if verbose mode is enabled.
      #
      # @return [Boolean]
      #
      # @api public
      #
      def verbose?
        @verbose
      end
    end
  end
end
