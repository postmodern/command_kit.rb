# frozen_string_literal: true

require 'command_kit/stdio'

module CommandKit
  #
  # Provides printing methods.
  #
  module Printing
    #
    # Includes {Stdio} into the command class which is also including
    # {Printing}.
    #
    def self.included(command)
      command.include Stdio
    end

    #
    # Prints the error to `$stderr`.
    #
    # @param [String] error
    #   The error message.
    #
    def print_error(error)
      stderr.puts error
    end

    #
    # Prints the backtrace of an exception to `$stderr`.
    #
    # @param [Exception] error
    #
    def print_backtrace(error)
      stderr.puts "Backtrace:"
      error.backtrace.reverse_each do |line|
        stderr.puts "\t#{line}"
      end
    end

    #
    # Prints an exception to `$stderr`.
    #
    # @param [Exception] error
    #
    def print_exception(error)
      print_backtrace(error)
      print_error "#{error.class}: #{error.message}"
    end
  end
end
