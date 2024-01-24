# frozen_string_literal: true

require_relative '../options'

module CommandKit
  module Options
    #
    # Defines a `-q`,`--quiet` option.
    #
    # ## Examples
    #
    #     include CommandKit::Options::Quiet
    #     
    #     def run(*argv)
    #       # ...
    #       puts "verbose output" unless quiet?
    #       # ...
    #     end
    #
    module Quiet
      include Options

      #
      # @api private
      #
      module ModuleMethods
        #
        # Defines a `-q, --quiet` option.
        #
        # @param [Class, Module] context
        #   The class or module including {Quiet}.
        #
        def included(context)
          super(context)

          if context.class == Module
            context.extend ModuleMethods
          else
            context.option :quiet, short: '-q', desc: 'Enables quiet output' do
              @quiet = true
            end
          end
        end
      end

      extend ModuleMethods

      #
      # Determines if quiet mode is enabled.
      #
      # @return [Boolean]
      #
      def quiet?
        @quiet
      end
    end
  end
end
