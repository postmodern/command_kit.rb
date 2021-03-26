require 'command_kit/options'

module CommandKit
  module Options
    #
    # Defines a `-v`,`--verbose` option.
    #
    # ## Examples
    #
    #     include Options::Verbose
    #
    #     def main(*argv)
    #       # ...
    #       puts "verbose output" if verbose?
    #       # ...
    #     end
    #
    module Verbose
      include Options

      module ModuleMethods
        #
        # Defines a `-v, --verbose` option.
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
      def verbose?
        @verbose
      end
    end
  end
end
