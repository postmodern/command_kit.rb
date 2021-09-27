# frozen_string_literal: true

require 'command_kit/env'

module CommandKit
  module Env
    #
    # Provides access to the `PATH` environment variable.
    #
    # ## Environment Variables
    #
    # * `PATH` - The list of directories to search for commands within.
    #
    module Path
      include Env

      # The home directory.
      #
      # @return [Array<String>]
      #
      # @api semipublic
      attr_reader :path_dirs

      #
      # Initializes {#path_dirs} using `env['PATH']`.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @api public
      #
      def initialize(**kwargs)
        super(**kwargs)

        @path_dirs = env.fetch('PATH','').split(File::PATH_SEPARATOR)
      end

      #
      # Searches for the command in {#path_dirs}.
      #
      # @param [String, Symbol] name
      #   The command name.
      #
      # @return [String, nil]
      #   The absolute path to the executable file, or `nil` if the command
      #   could not be found in any of the {#path_dirs}.
      #
      # @api public
      #
      def find_command(name)
        name = name.to_s

        @path_dirs.each do |dir|
          file = File.join(dir,name)

          return file if File.file?(file) && File.executable?(file)
        end

        return nil
      end

      #
      # Determines if the command is present on the system.
      #
      # @param [String, Symbol] name
      #   The command name.
      #
      # @return [Boolean]
      #   Specifies whether a command with the given name exists in one of the
      #   {#path_dirs}.
      #
      # @example
      #   if command_installed?("docker")
      #     # ...
      #   else
      #     abort "Docker is not installed. Aborting"
      #   end
      #
      # @api public
      #
      def command_installed?(name)
        !find_command(name).nil?
      end
    end
  end
end
