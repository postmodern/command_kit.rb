require 'command_kit/main'
require 'command_kit/printing'

module CommandKit
  #
  # Adds exception handling and printing.
  #
  # ## Examples
  #
  #     include CommandKit::Main
  #     include CommandKit::ExceptionHandler
  #
  # ### Custom Exception Handling
  #
  #     include CommandKit::Main
  #     include CommandKit::ExceptionHandler
  #     
  #     def on_exception(error)
  #       print_error "error: #{error.message}"
  #       exit(1)
  #     end
  #
  module ExceptionHandler
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
    # @api public
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
    # @api semipublic
    #
    def on_exception(error)
      print_exception(error)
      exit(1)
    end
  end
end
