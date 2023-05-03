require 'command_kit/command'

module Foo
  class CLI
    class Config < CommandKit::Command
      #
      # The `config set` sub-command.
      #
      class Set < CommandKit::Command

        usage '[options] NAME'

        argument :name, required: true,
                        desc:     'Configuration variable name to set'

        argument :value, required: true,
                         desc:     'Configuration variable value to set'

        description 'Sets a configuration variable'

        CONFIG = {
          'name'  => 'John Smith',
          'email' => 'john.smith@example.com'
        }

        #
        # Runs the `config get` sub-command.
        #
        # @param [String] name
        #   The name argument.
        #
        def run(name,value)
          unless CONFIG.has_key?(name)
            print_error "unknown config variable: #{name}"
            exit(1)
          end

          puts "Configuration variable #{name} was #{CONFIG.fetch(name)}, but is now #{value}"
        end

      end
    end
  end
end
