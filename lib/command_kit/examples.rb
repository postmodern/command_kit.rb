require 'command_kit/help'

module CommandKit
  #
  # Allows defining example commands for the command class.
  #
  #     include CommandKit::Examples
  #     
  #     examples [
  #       "my_cmd -o output.txt  path/to/file"
  #     ]
  #
  module Examples
    #
    # Includes {Help} and extends {Examples::ClassMethods}.
    #
    # @param [Class] base
    #   The command class which is including {Examples}.
    #
    def self.included(command)
      command.include Help
      command.extend ClassMethods
    end

    #
    # Defines class-level methods.
    #
    module ClassMethods
      #
      # Gets or sets the example commands.
      #
      # @param [Array<String>, String, nil] new_examples
      #   If a String or Array of Strings is given, it will set the class'es
      #   example commands.
      #
      # @return [Array<String>, nil]
      #   The class'es or superclass'es example commands.
      #
      # @example
      #   examples [
      #     "-o output.txt path/to/file"
      #   ]
      #   
      def examples(new_examples=nil)
        if new_examples
          @examples = Array(new_examples)
        else
          if @examples
            @examples.map { |command| "#{command_name} #{command}" }
          elsif superclass.include?(ClassMethods)
            superclass.examples
          end
        end
      end
    end

    #
    # Prints the command class'es example commands.
    #
    def help
      super

      if (examples = self.class.examples)
        puts
        puts "Examples:"
        examples.each do |command|
          puts "    #{command_name} #{command}"
        end
      end
    end
  end
end
