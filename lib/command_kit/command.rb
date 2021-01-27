require 'command_kit/main'
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
  #     class MyCmd < CommandKit::Command
  #     
  #       # ...
  #     
  #     end
  #
  class Command

    def self.inherited(subclass)
      subclass.include Main
      subclass.include Help
      subclass.include Usage
      subclass.include Options
      subclass.include Arguments
      subclass.include Examples
      subclass.include Description
      subclass.include Backtrace
      subclass.include Exit
    end

  end
end
