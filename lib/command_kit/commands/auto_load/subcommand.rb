require 'command_kit/commands/subcommand'

module CommandKit
  module Commands
    class AutoLoad < Module
      class Subcommand < Commands::Subcommand

        # The fully qualified constant of the command class.
        #
        # @return [String]
        attr_reader :constant

        # The path to the file containing the command class.
        #
        # @return [String]
        attr_reader :path

        # A short summary for the sub-command.
        #
        # @return [String, nil]
        attr_reader :summary

        #
        # Initializes the lazy-loaded subcommand.
        #
        # @param [String] path
        #
        # @param [String] constant
        #
        # @param [String, nil] summary
        #
        def initialize(constant,path, summary: nil)
          @constant   = constant
          @path       = path

          super(nil, summary: summary)
        end

        #
        # Requires the file.
        #
        # @return [Boolean]
        #
        def require!
          require(@path)
        end

        #
        # Resolves the {#constant} for the command class.
        #
        # @return [Class]
        #   The command class.
        #
        # @raise [NameError]
        #   The command class could not be found.
        #
        def const_get
          Object.const_get("::#{@constant}",false)
        end

        #
        # Lazy-loads the command class.
        #
        # @return [Class]
        #   The command class.
        #
        # @raise [LoadError]
        #   Could not load the given {#path}.
        #
        # @raise [NameError]
        #   Could not resolve the {#constant} for the command class.
        #
        def command
          @command ||= (
            require!
            const_get
          )
        end

      end
    end
  end
end
