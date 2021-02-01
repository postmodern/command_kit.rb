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
      #
      # Includes {Options} and defines a `-v, --verbose` option.
      #
      def self.included(command)
        command.include Options

        command.option :verbose, short: '-v', desc: 'Enables verbose output' do
          @verbose = true
        end
      end

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
