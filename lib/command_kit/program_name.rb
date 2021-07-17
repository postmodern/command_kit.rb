module CommandKit
  #
  # Retrieves the current program name (`$PROGRAM_NAME`).
  #
  module ProgramName
    #
    # @api private
    #
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether
      # {ProgramName} is being included into a class or a module.
      #
      # @param [Class, Module] context
      #   The class or module which is including {ProgramName}.
      #
      def included(context)
        super(context)

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
      # List of `$PROGRAM_NAME`s that should be ignored.
      IGNORED_PROGRAM_NAMES = [
        '-e',   # ruby -e "..."
        'irb',  # running in irb
        'rspec' # running in rspec
      ]

      #
      # The current program name (`$PROGRAM_NAME`).
      #
      # @return [String, nil]
      #   The `$PROGRAM_NAME` or `nil` if the `$PROGRAM_NAME` is `-e`, `irb`,
      #   or `rspec`.
      #
      # @api semipublic
      #
      def program_name
        $PROGRAM_NAME unless IGNORED_PROGRAM_NAMES.include?($PROGRAM_NAME)
      end
    end

    #
    # @see ClassMethods#program_name
    #
    # @api public
    #
    def program_name
      self.class.program_name
    end
  end
end
