require 'command_kit/main'
require 'command_kit/env'
require 'command_kit/stdio'
require 'command_kit/printing'
require 'command_kit/usage'
require 'command_kit/arguments'
require 'command_kit/options'
require 'command_kit/examples'
require 'command_kit/description'
require 'command_kit/exception_handler'

module CommandKit
  #
  # The command class base-class.
  #
  # ## Examples
  #
  #     class MyCmd < CommandKit::Command
  #     
  #       # ...
  #     
  #     end
  #
  # @note Command classes are not required to inherit from {Command}. This class
  # only exists as a convenience.
  #
  class Command

    include Main
    include Env
    include Stdio
    include Printing
    include Help
    include Usage
    include Arguments
    include Options
    include Examples
    include Description
    include ExceptionHandler

  end
end
