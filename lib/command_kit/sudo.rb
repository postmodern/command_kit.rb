# frozen_string_literal: true

require_relative 'os'

module CommandKit
  #
  # Allows running commands with `sudo`.
  #
  # @since 0.2.0
  #
  module Sudo
    include OS

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
      if windows?
        system('runas','/user:administrator',command,*arguments)
      else
        if Process.uid == 0
          system(command,*arguments)
        else
          system('sudo',command,*arguments)
        end
      end
    end
  end
end
