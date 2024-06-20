# frozen_string_literal: true

require_relative 'stdio'
require_relative 'printing'

module CommandKit
  #
  # Adds helper methods for opening files.
  #
  # ## Features
  #
  # * Prints `No such file or directory` error if the given file does not exist.
  # * Handles `-` file paths which indicate input should be read from STDIN or
  #   output written to STDOUT.
  #
  # ## Examples
  #
  #     include CommandKit::Open
  #
  #     def run(path)
  #       open(path) do |file|
  #         # ...
  #       end
  #     end
  #
  # @since 0.6.0
  #
  module Open
    include Stdio
    include Printing

    #
    # Opens a file for reading or writing.
    #
    # @param [String] path
    #   The path of the given file. May be `"-"` to indicate that input should
    #   be read from STDINT or output written to STDOUT.
    #
    # @param [String] mode
    #   The mode to open the file with.
    #
    # @yield [file]
    #   * If the given path is `"-"`.
    #     * and the given mode contains `w` or `a`, then {#stdout} will be
    #       yielded.
    #     * and no mode is given or if the mode contains `r`, then {#stdin} will
    #       be yielded.
    #   * Otherwise, the newly opened file.
    #
    # @yieldparam [File, IO] file
    #   The newly opened file, or {#stdin} / {#stdout} if the given path is
    #   `"-"`.
    #
    # @return [File, IO, Object]
    #   * If no block is given, the newly opened file, or {#stdin} / {#stdout}
    #     if the given path is `"-"`, will be returned.
    #   * If a block was given, then the return value of the block will be
    #     returned.
    #
    # @example Opening a file for reading:
    #   open(path)
    #   # => #<File:...>
    #
    # @example Temporarily opening a file for reading:
    #   open(path) do |file|
    #     # ...
    #   end
    #
    # @example Opening a file for writing:
    #   open(path,'w')
    #   # => #<File:...>
    #
    # @example Temporarily opening a file for writing:
    #   open(path,'w') do |output|
    #     output
    #   end
    #
    # @api public
    #
    # @since 0.6.0
    #
    def open(path,mode='r',&block)
      if path == '-'
        io = case mode
             when /[wa]/ then stdout
             else             stdin
             end

        if block_given?
          return yield(io)
        else
          return io
        end
      end

      begin
        File.open(path,mode,&block)
      rescue Errno::ENOENT
        print_error "No such file or directory: #{path}"
        exit(1)
      end
    end
  end
end
