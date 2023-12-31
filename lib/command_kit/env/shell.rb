# frozen_string_literal: true

require 'command_kit/env'

module CommandKit
  module Env
    #
    # Methods related to the `SHELL` environment variable.
    #
    # ## Environment Variables
    #
    # * `SHELL` - The current shell.
    #
    # @since 0.5.0
    #
    module Shell
      include Env

      # The current shell.
      #
      # @return [String, nil]
      attr_reader :shell

      # The current shell type.
      #
      # @return [:bash, :zsh, :dash, :mksh, :ksh, :tcsh, :csh, :sh, nil]
      attr_reader :shell_type

      #
      # Initialize {#shell} and {#shell_type} based on the `SHELL` environment
      # variable.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @api public
      #
      def initialize(**kwargs)
        super(**kwargs)

        @shell      = env['SHELL']
        @shell_type = if @shell
                        case File.basename(@shell)
                        when /bash/ then :bash
                        when /zsh/  then :zsh
                        when /dash/ then :dash
                        when /mksh/ then :mksh
                        when /ksh/  then :ksh
                        when /tcsh/ then :tcsh
                        when /csh/  then :csh
                        when /sh/   then :sh
                        end
                      end
      end
    end
  end
end
