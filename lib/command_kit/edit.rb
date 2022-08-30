# frozen_string_literal: true

require 'command_kit/env'

module CommandKit
  #
  # Allows invoking the `EDITOR` environment variable.
  #
  # ## Environment Variables
  #
  # * `EDITOR` - The preferred editor command.
  #
  # @since 0.4.0
  #
  module Edit
    include Env

    #
    # The `EDITOR` environment variable.
    #
    # @return [String]
    #   The `EDITOR` environment variable, or `"nano"` if `EDITOR` was not set.
    #
    # @api semipublic
    #
    def editor
      env['EDITOR'] || 'nano'
    end

    #
    # Invokes the preferred editor with the additional arguments.
    #
    # @param [Array] arguments
    #   The additional arguments to pass to the editor command.
    #
    # @return [Boolean, nil]
    #   Indicates whether the editor successfully launched and exited.
    #   If the {#editor} command was not installed, `nil` will be returned.
    #
    # @api public
    #
    def edit(*arguments)
      if editor
        system(editor,*arguments.map(&:to_s))
      end
    end
  end
end
