# frozen_string_literal: true

require 'command_kit/stdio'

module CommandKit
  #
  # Provides printing methods.
  #
  module Printing
    include Stdio

    # Platform independent new-line constant
    #
    # @return [String]
    #
    # @api public
    EOL = $/

    #
    # Prints the error message to {Stdio#stderr stderr}.
    #
    # @param [String] message
    #   The error message.
    #
    # @example
    #   print_error "error: invalid input"
    #   # error: invalid input
    #
    # @example When CommandKit::CommandName is included:
    #   print_error "invalid input"
    #   # foo: invalid input
    #
    # @api public
    #
    def print_error(message)
      if respond_to?(:command_name)
        # if #command_name is available, prefix all error messages with it
        stderr.puts "#{command_name}: #{message}"
      else
        # if #command_name is not available, just print the error message as-is
        stderr.puts message
      end
    end

    #
    # Prints an exception to {Stdio#stderr stderr}.
    #
    # @param [Exception] error
    #   The error to print.
    #
    # @example
    #   begin
    #     # ...
    #   rescue => error
    #     print_error "Error encountered"
    #     print_exception(error)
    #     exit(1)
    #   end
    #
    # @api public
    #
    def print_exception(error)
      print_error error.full_message(highlight: stderr.tty?)
    end
    
    #
    # Prints a bulleted list of items.
    #
    # @param [Array] list
    #   The list of items to print.
    #
    # @param [String] bullet
    #   The bullet character to use for line item.
    #
    # @example
    #   print_list %w[foo bar baz]
    #   # * foo
    #   # * bar
    #   # * baz
    #
    # @example with a custom bullet character:
    #   print_list %w[foo bar baz], bullet: '-'
    #   # - foo
    #   # - bar
    #   # - baz
    #
    # @since 0.4.0
    #
    def print_list(list, bullet: '*')
      list.each do |item|
        puts "#{bullet} #{item}"
      end
    end

    #
    # Prints a Hash as left-justified `:` separated fields.
    #
    # @param [Hash, Array<(Object, Object)>] fields
    #   The fields to print.
    #
    # @example
    #   print_fields('Name' => 'foo', 'Version' => '0.1.0')
    #   # Name:    foo
    #   # Version: 0.1.0
    #
    # @api public
    #
    # @since 0.4.0
    #
    def print_fields(fields)
      max_length = 0

      fields = fields.map { |name,value|
        name       = name.to_s
        value      = value.to_s
        max_length = name.length if name.length > max_length

        [name, value]
      }

      max_length += 1

      fields.each do |name,value|
        header = "#{name}:".ljust(max_length)

        puts "#{header} #{value}"
      end

      return nil
    end
  end
end
