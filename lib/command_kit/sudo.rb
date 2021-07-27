# frozen_string_literal: true

module CommandKit
  #
  # Allows running commands with `sudo`.
  #
  # @since 0.2.0
  #
  module Sudo
    #
    # Runs the command under sudo, if the user isn't already root.
    #
    # @param [String] command
    #   The command to execute.
    #
    # @param [Array<String>] arguments
    #   Additional arguments for the command.
    #
    # @return [Boolean, nil]
    #   Specifies whether the command was successfully ran or not.
    #
    # @api public
    #
    def sudo(command,*arguments)
      if Process.uid == 0
        system(command,*arguments)
      else
        system('sudo',command,*arguments)
      end
    end
  end
end
