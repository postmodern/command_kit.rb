# frozen_string_literal: true

require 'command_kit/command'
require 'command_kit/commands/parent_command'

module CommandKit
  module Commands
    #
    # The default help command.
    #
    # @api semipublic
    #
    class Help < Command

      include ParentCommand

      argument :command, required: false,
                         desc: 'Command name to lookup'

      #
      # Prints the given commands `--help` output or lists registered commands.
      #
      # @param [String, nil] command
      #   The given command name, or `nil` if no command name was given.
      #
      def run(command=nil)
        case command
        when nil
          parent_command.help
        else
          if (subcommand = parent_command.command(command))
            unless subcommand.respond_to?(:help)
              raise(TypeError,"#{subcommand.inspect} must define a #help method")
            end

            subcommand.help
          else
            print_error "unknown command: #{command}"
            exit(1)
          end
        end
      end

    end
  end
end
