# frozen_string_literal: true

require_relative '../printing'
require_relative '../env/home'
require_relative '../env/shell'
require_relative '../env/prefix'

require 'fileutils'

module CommandKit
  module Completion
    #
    # Mixins that adds methods for installing shell completion files.
    #
    # ## Environment Variables
    #
    # * `SHELL` - The current shell.
    # * `PREFIX` - The optional root prefix of the file-system.
    #
    # @api public
    #
    # @since 0.5.0
    #
    module Install
      include Printing
      include Env::Home
      include Env::Shell
      include Env::Prefix

      # The installation directory for completion files for the current shell.
      #
      # @return [String, nil]
      #   * Bash
      #     * Regular users: `~/.local/share/bash-completion/completions`
      #     * Root users:`$PREFIX/usr/local/share/bash-completion/completions`
      #   * Zsh: `$PREFIX/usr/local/share/zsh/site-functions`
      #   * Fish:
      #     * Regular users: `~/.config/fish/completions`
      #     * Root users: `$PREFIX/usr/local/share/fish/completions`
      #
      # @api private
      attr_reader :completions_dir

      #
      # Initialize {#completions_dir} based on the `SHELL` environment variable
      # and the UID of the process.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @api public
      #
      def initialize(**kwargs)
        super(**kwargs)

        @completions_dir = case shell_type
                           when :bash
                             if Process.uid == 0
                               File.join(root,'usr','local','share','bash-completion','completions')
                             else
                               xdg_data_home = env.fetch('XDG_DATA_HOME') do
                                 File.join(home_dir,'.local','share')
                               end

                               File.join(xdg_data_home,'bash-completion','completions')
                             end
                           when :zsh
                             File.join(root,'usr','local','share','zsh','site-functions')
                           when :fish
                             if Process.uid == 0
                               File.join(root,'usr','local','share','fish','completions')
                             else
                               xdg_config_home = env.fetch('XDG_CONFIG_HOME') do
                                 File.join(home_dir,'.config')
                               end

                               File.join(xdg_config_home,'fish','completions')
                             end
                           end
      end

      #
      # Prints the shell completion file to stdout.
      #
      # @param [String] path
      #   The path to the shell completion file.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @option kwargs [:bash, :zsh, :fish] :type (:bash)
      #   The type of the completion file.
      #
      # @example Prints a Bash completion file:
      #   print_completion_file 'path/to/completions/foo'
      #
      # @example Prints a Zsh completion file:
      #   print_completion_file 'path/to/completions/foo', type: :zsh
      #
      # @example Prints a Fish completion file:
      #   print_completion_file 'path/to/completions/foo', type: :fish
      #
      # @api public
      #
      def print_completion_file(path,**kwargs)
        write_completion_file(path,stdout,**kwargs)
      end

      #
      # Installs the shell completion file into {#completions_dir}.
      #
      # @param [String] path
      #   The path to the shell completion file.
      #
      # @param [:bash, :zsh, :fish] type
      #   The type of the shell completion file.
      #
      # @example Install a Bash completion file:
      #   install_completion_file 'path/to/completions/foo'
      #
      # @example Install a Zsh completion file:
      #   install_completion_file 'path/to/completions/foo', type: :zsh
      #
      # @example Install a Fish completion file:
      #   install_completion_file 'path/to/completions/foo', type: :fish
      #
      # @api public
      #
      def install_completion_file(path, type: :bash)
        completion_file = normalize_completion_file(path, type: type)
        completion_path = File.join(@completions_dir,completion_file)

        begin
          ::FileUtils.mkdir_p(@completions_dir)
        rescue Errno::EACCES
          print_error "cannot write to #{shell_type} completions directory: #{@completions_dir}"
          exit(-1)
        end

        begin
          File.open(completion_path,'w') do |output|
            write_completion_file(path,output, type: type)
          end
        rescue Errno::EACCES
          print_error "cannot write to #{shell_type} completion file: #{completion_path}"
          exit(-1)
        end
      end

      #
      # Uninstalls a shell completion file for the specified command.
      #
      # @param [String] command
      #   The command to uninstall the completions for.
      #
      # @example Removes the completion file for the command 'foo':
      #   uninstall_completion_file_for 'foo'
      #
      # @api public
      #
      def uninstall_completion_file_for(command)
        completion_file = completion_file_for_command(command)
        completion_path = File.join(@completions_dir,completion_file)

        begin
          ::FileUtils.rm_f(completion_path)
        rescue Errno::EACCES
          print_error "cannot remove #{shell_type} completion file: #{completion_path}"
          exit(-1)
        end
      end

      private

      #
      # Calculates the installed completion file for the given command.
      #
      # @param [String] command
      #   The command name.
      #
      # @return [String]
      #   The path to the completion file for the command.
      #
      # @api private
      #
      def completion_file_for_command(command)
        case shell_type
        when :bash then command
        when :zsh  then "_#{command}"
        when :fish then "#{command}.fish"
        when nil
          if shell then print_error("cannot identify shell: #{shell}")
          else          print_error("cannot identify shell")
          end

          exit(-1)
        else
          print_error("completions not support for the #{shell_type} shell: #{shell}")
          exit(-1)
        end
      end

      #
      # Calculates the installation path for the given completion file.
      #
      # @param [String] path
      #   The path to the completion file that will be installed.
      #
      # @param [:bash, :zsh, :fish] type
      #   The type of the shell completion file.
      #
      # @return [String]
      #   The installation path for the completion file.
      #
      # @api private
      #
      def normalize_completion_file(path, type: :bash)
        ext  = File.extname(path)
        file = File.basename(path,ext)

        case [shell_type, type]
        when [:bash, :bash] # no-op
        when [:zsh, :zsh],
             [:zsh, :bash]
          unless file.start_with?('_')
            file = "_#{file}"
          end
        when [:fish, :fish]
          file = "#{file}.fish"
        else
          if shell_type
            print_error("cannot install #{type} completion file into the #{shell_type} shell: #{path}")
          elsif shell
            print_error("cannot identify shell: #{shell}")
          else
            print_error("cannot identify shell")
          end

          exit(-1)
        end

        return file
      end

      #
      # Writes the shell completion file to the output
      #
      # @param [String] path
      #   The path to the shell completion file.
      #
      # @param [IO] output
      #   The output stream to write to.
      #
      # @param [:bash, :zsh, :fish] type
      #   The type of the shell completion file.
      #
      # @api private
      #
      def write_completion_file(path,output, type: :bash)
        if shell_type == :zsh && type == :bash
          file_name = File.basename(path,File.extname(path))
          command   = file_name.sub(/\A_/,'')

          # add the #compdef magic comments for zsh
          output.puts "#compdef #{command}"
          output.puts
        end

        File.open(path) do |file|
          file.each_line do |line|
            output.write(line)
          end
        end
      end
    end
  end
end
