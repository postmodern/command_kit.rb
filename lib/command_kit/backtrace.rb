require 'command_kit/printing'

module CommandKit
  #
  # Adds exception handling and backtrace printing.
  #
  # ## Examples
  #
  #     include CommandKit::Backtrace
  #
  module Backtrace
    include Printing

    #
    # Prepends {Backtrace::Main}.
    #
    # @param [Class] command
    #   The command class which is including {Backtrace}.
    #
    def self.included(command)
      command.prepend Backtrace::Main
    end

    #
    # Overrides `main` to catch any uncaught exceptions and print them.
    #
    module Main
      #
      # Calls `main` but catches and prints any uncaught exceptions.
      #
      # @param [Array<String>] argv
      #   The given arguments Array.
      #
      def main(*argv)
        super(*argv)
      rescue Interrupt, Errno::EPIPE => error
        raise(error)
      rescue Exception => error
        print_exception(error)
        exit(1)
      end
    end
  end
end
