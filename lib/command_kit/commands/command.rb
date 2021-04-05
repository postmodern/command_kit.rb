require 'command_kit/command'
require 'command_kit/commands/parent_command'

module CommandKit
  module Commands
    class Command < CommandKit::Command

      include ParentCommand

    end
  end
end
