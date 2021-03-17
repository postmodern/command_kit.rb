require 'command_kit/command_name'

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
    #
    # Includes {CommandName} and extends {Usage::ClassMethods}.
    #
    # @param [Class] command
    #   The class which is including {Usage}.
    #
    def self.included(command)
      command.include CommandName
      command.extend ClassMethods
    end

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
    def help
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
  end
end
