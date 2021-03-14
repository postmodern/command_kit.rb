require 'command_kit/printing'

module CommandKit
  #
  # Adds exception handling and backtrace printing.
  #
  # ## Examples
  #
  #     include CommandKit::Backtrace
  #
  # ### Custom Exception Handling
  #
  #     include CommandKit::Backtrace
  #     
  #     def on_exception(error)
  #       print_error "error: #{error.message}"
  #       exit(1)
  #     end
  #
  module Backtrace
    include Printing

    #
    # Calls superclass'es `#main` method, but rescues any uncaught exceptions
    # and passes them to {#on_exception}.
    #
    # @param [Array<String>] argv
    #   The given arguments Array.
    #
    # @return [Integer]
    #   The exit status of the command.
    #
    def main(argv=[])
      super(argv)
    rescue Interrupt, Errno::EPIPE => error
      raise(error)
    rescue Exception => error
      on_exception(error)
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
