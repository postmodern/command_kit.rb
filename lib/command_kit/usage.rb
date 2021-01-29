require 'command_kit/command_name'

module CommandKit
  #
  # Defines the usage string for a command class.
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
    # @see ClassMethods#usage
    #
    def usage
      self.class.usage
    end

    #
    # Prints the `usage: ...` output.
    #
    def help
      case (usage = self.usage)
      when Array
        puts "usage: #{command_name} #{usage[0]}"

        usage[1..].each do |command|
          puts "       #{command_name} #{command}"
        end
      when String
        puts "usage: #{command_name} #{usage}"
      end
    end
  end
end
