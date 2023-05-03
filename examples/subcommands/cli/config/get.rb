require 'command_kit/command'

module Foo
  class CLI
    class Config < CommandKit::Command
      #
      # The `config get` sub-command.
      #
      class Get < CommandKit::Command

        usage '[options] NAME'

        argument :name, required: false,
                        desc:     'Configuration variable name'

        description 'Gets a configuration variable'

        CONFIG = {
          'name'  => 'John Smith',
          'email' => 'john.smith@example.com'
        }

        #
        # Runs the `config get` sub-command.
        #
        # @param [String, nil] name
        #   The optional name argument.
        #
        def run(name=nil)
          if name
            unless CONFIG.has_key?(name)
              print_error "unknown config variable: #{name}"
              exit(1)
            end

            puts CONFIG.fetch(name)
          else
            CONFIG.each do |name,value|
              puts "#{name}:\t#{value}"
            end
          end
        end

      end
    end
  end
end
