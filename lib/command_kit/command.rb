require 'command_kit/main'
require 'command_kit/env'
require 'command_kit/stdio'
require 'command_kit/printing'
require 'command_kit/usage'
require 'command_kit/arguments'
require 'command_kit/options'
require 'command_kit/examples'
require 'command_kit/description'
require 'command_kit/backtrace'
require 'command_kit/exit'

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
  class Command

    def self.inherited(subclass)
      subclass.include Main
      subclass.include Env
      subclass.include Stdio
      subclass.include Printing
      subclass.include Help
      subclass.include Usage
      subclass.include Arguments
      subclass.include Options
      subclass.include Examples
      subclass.include Description
      subclass.include Backtrace
      subclass.include Exit
    end

  end
end
