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
      # Calls `#main` but catches and calls
      # {Backtrace#on_exception #on_exception} any uncaught exceptions.
      #
      # @param [Array<String>] argv
      #   The given arguments Array.
      #
      def main(*argv)
        super(*argv)
      rescue Interrupt, Errno::EPIPE => error
        raise(error)
      rescue Exception => error
        on_exception(error)
      end
    end

    #
    # Default method for handling when an exception is raised by `#main`.
    #
    # @param [Exception] error
    #   The raised exception.
    #
    def on_exception(error)
      print_exception(error)
      exit(1)
    end
  end
end
