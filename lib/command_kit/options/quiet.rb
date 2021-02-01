require 'command_kit/options'

module CommandKit
  module Options
    #
    # Defines a `-q`,`--quiet` option.
    #
    # ## Examples
    #
    #     include CommandKit::Options::Quiet
    #     
    #     def main(*argv)
    #       # ...
    #       puts "verbose output" unless quiet?
    #       # ...
    #     end
    #
    module Quiet
      #
      # Includes {Options} and defines a `-q, --quiet` option.
      #
      def self.included(command)
        command.include Options

        command.option :quiet, short: '-q', desc: 'Enables quiet output' do
          @quiet = true
        end
      end

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
