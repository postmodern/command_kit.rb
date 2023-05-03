require 'command_kit/command'
require 'command_kit/commands'

require_relative './config/get'
require_relative './config/set'

module Foo
  class CLI
    #
    # The `config` sub-command.
    #
    class Config < CommandKit::Command

      include CommandKit::Commands

      command Get
      command Set

      description 'Get or set the configuration'

    end
  end
end
