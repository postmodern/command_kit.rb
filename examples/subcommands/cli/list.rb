require 'command_kit/command'

module Foo
  class CLI
    #
    # The `list` sub-command.
    #
    class List < CommandKit::Command

      usage '[options] [NAME]'

      argument :name, required: false,
                      desc:     'Optional name to list'

      description 'Lists the contents'

      ITEMS = %w[foo bar baz]

      #
      # Runs the `list` sub-command.
      #
      # @param [String, nil] name
      #   The optional name argument.
      #
      def run(name=nil)
        if name
          puts ITEMS.grep(name)
        else
          puts ITEMS
        end
      end

    end
  end
end
