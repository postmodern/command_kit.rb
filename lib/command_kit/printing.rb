# frozen_string_literal: true

require 'command_kit/stdio'

module CommandKit
  #
  # Provides printing methods.
  #
  module Printing
    include Stdio

    # Platform independency new-line constant
    #
    # @return [String]
    EOL = $/

    #
    # Prints the error message to {Stdio#stderr stderr}.
    #
    # @param [String] message
    #   The error message.
    #
    # @example
    #   print_error "Error: invalid input"
    #
    def print_error(message)
      stderr.puts message
    end

    #
    # Prints an exception to {Stdio#stderr stderr}.
    #
    # @param [Exception] error
    #   The error to print.
    #
    # @example
    #   begin
    #     # ...
    #   rescue => error
    #     print_error "Error encountered"
    #     print_exception(error)
    #     exit(1)
    #   end
    #
    def print_exception(error)
      print_error error.full_message(highlight: stderr.tty?)
    end
  end
end
