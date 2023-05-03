require 'command_kit/command'

module Foo
  class CLI
    #
    # The `update` sub-command.
    #
    class Update < CommandKit::Command

      usage '[options] [NAME]'

      option :quiet, short: '-q',
                     desc:  'Suppresses logging messages'

      argument :name, required: false,
                      desc:     'Optional name to update'

      description 'Updates an item or all items'

      ITEMS = %w[foo bar baz]

      #
      # Runs the `update` sub-command.
      #
      # @param [String, nil] name
      #   The optional name argument.
      #
      def run(name=nil)
        if name
          unless ITEMS.include?(name)
            print_error "unknown item: #{name}"
            exit(1)
          end

          puts "Updating #{name} ..." unless options[:quiet]
          sleep 1
          puts "Item #{name} updated." unless options[:quiet]
        else
          puts "Updating ..." unless options[:quiet]
          sleep 2
          puts "All items updated." unless options[:quiet]
        end
      end

    end
  end
end
