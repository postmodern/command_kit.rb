# frozen_string_literal: true

require 'command_kit/env'
require 'command_kit/env/path'
require 'command_kit/stdio'
require 'command_kit/terminal'

module CommandKit
  #
  # Allows opening a pager, such as `less` or `more`.
  #
  # ## Examples
  #
  #     class CLI < CommandKit::Command
  #
  #       include CommandKit::Pager
  #
  #       def run
  #         pager do |io|
  #           io.puts "This goes into the pager screen"
  #         end
  #       end
  #
  #     end
  #
  # ## Environment Variables
  #
  # * `PAGER` - The optional command to override the default pager (usually
  #   `less -r` or `more -r`).
  # * `PATH` - The list of directories to search for the default pager program
  #   (either `less` or `more`).
  #
  # ## Alternatives
  #
  # * [tty-pager](https://github.com/piotrmurach/tty-pager#readme)
  #
  module Pager
    include Env
    include Env::Path
    include Stdio
    include Terminal

    # Common pager commands.
    PAGERS = ['less -r', 'more -r']

    #
    # Initializes the pager.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Keyword arguments.
    #
    # @note
    #   Respects the `PAGER` env variable, or attemps to find `less` or
    #   `more` by searching the `PATH` env variable.
    #
    # @api public
    #
    def initialize(**kwargs)
      super(**kwargs)

      @pager_command = env.fetch('PAGER') do
        PAGERS.find do |command|
          bin = command.split(' ',2).first

          command_installed?(bin)
        end
      end
    end

    #
    # Opens a pager pipe.
    #
    # @yield [io]
    #   The given block will be passed the IO pipe to the pager.
    #
    # @yieldparam [IO]
    #   The IO pipe to the pager.
    #
    # @example
    #   pager do |io|
    #     io.puts "Hello world"
    #     # ...
    #   end
    #
    # @example Piping a command into the pager:
    #   IO.peopn(["ping", ip]) do |ping|
    #     pager do |io|
    #       ping.each_line do |line|
    #         io.write line
    #       end
    #     end
    #   end
    #
    # @api public
    #
    def pager
      if !stdout.tty? || @pager_command.nil?
        # fallback to stdout if the process does not have a terminal or we could
        # not find a suitable pager command.
        yield stdout
        return
      end

      io  = IO.popen(@pager_command,'w')
      pid = io.pid

      begin
        yield io
      rescue Errno::EPIPE
      ensure
        io.close

        begin
          Process.waitpid(pid)
        rescue Errno::EPIPE, Errno::ECHILD
        end
      end
    end

    #
    # Pages the data if it's longer the terminal's height, otherwise prints the
    # data to {Stdio#stdout stdout}.
    #
    # @param [Array<String>, #to_s] data
    #   The data to print.
    #
    # @example
    #   print_or_page(data)
    #
    # @example Print or pages the contents of a file:
    #   print_or_page(File.read(file))
    #
    # @api public
    #
    def print_or_page(data)
      line_count = case data
                   when Array  then data.length
                   else             data.to_s.each_line.count
                   end

      if line_count > terminal_height
        pager { |io| io.puts(data) }
      else
        stdout.puts(data)
      end
    end
  end
end
