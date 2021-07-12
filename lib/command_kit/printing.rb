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
    def print_error(message)
      stderr.puts message
    end

    #
    # Prints an exception to {Stdio#stderr stderr}.
    #
    # @param [Exception] error
    #   The error to print.
    #
    def print_exception(error)
      print_error error.full_message(highlight: stderr.tty?)
    end
  end
end
