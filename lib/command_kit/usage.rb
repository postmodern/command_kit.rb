# frozen_string_literal: true

require_relative 'command_name'
require_relative 'help'

module CommandKit
  #
  # Defines the usage string for a command class.
  #
  # ## Examples
  #
  #     include CommandKit::Usage
  #
  #     usage "[options] ARG1 ARG2 [ARG3 ...]"
  #
  module Usage
    include CommandName
    include Help

    #
    # @api private
    #
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether {Usage}
      # is being included into a class or module.
      #
      # @param [Class, Module] context
      #   The class or module which is including {Usage}.
      #
      def included(context)
        super

        if context.class == Module
          context.extend ModuleMethods
        else
          context.extend ClassMethods
        end
      end
    end

    extend ModuleMethods

    #
    # Class-level methods.
    #
    module ClassMethods
      #
      # Gets or sets the class'es usage string(s).
      #
      # @param [String, Array<String>, nil] new_usage
      #   If a new_usage argument is given, it will set the class'es usage
      #   string(s).
      #
      # @return [String, Array<String>]
      #   The class'es or superclass'es usage string(s).
      #
      # @example
      #   usage "[options] ARG1 ARG2 [ARG3 ...]"
      #
      # @api public
      #
      def usage(new_usage=nil)
        if new_usage
          @usage = new_usage
        else
          @usage || (superclass.usage if superclass.kind_of?(ClassMethods))
        end
      end
    end

    #
    # Similar to {ClassMethods#usage .usage}, but prepends
    # {CommandName#command_name command_name}.
    #
    # @return [Array<String>, String, nil]
    #
    # @api public
    #
    def usage
      case (usage = self.class.usage)
      when Array
        usage.map { |command| "#{command_name} #{command}" }
      when String
        "#{command_name} #{usage}"
      end
    end

    #
    # Prints the `usage: ...` output.
    #
    # @api semipublic
    #
    def help_usage
      case (usage = self.usage)
      when Array
        puts "usage: #{usage[0]}"

        usage[1..].each do |command|
          puts "       #{command}"
        end
      when String
        puts "usage: #{usage}"
      end
    end

    #
    # Prints the usage.
    #
    # @see #help_usage
    #
    # @api public
    #
    def help
      help_usage
    end
  end
end
