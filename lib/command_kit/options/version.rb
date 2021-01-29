require 'command_kit/options'

module CommandKit
  module Options
    #
    # Defines a version option.
    #
    module Version
      #
      # Includes {Options}, extends {Version::ClassMethods}, and defines a
      # `-V, --version` option.
      #
      def self.included(base)
        base.include Options
        base.extend ClassMethods

        base.option :version, short: '-V',
                              desc: 'Prints the version and exits' do
          base.print_version
          base.exit(0)
        end
      end

      #
      # Defines class-level methods.
      #
      module ClassMethods
        #
        # Gets or sets the version string.
        #
        # @param [String, nil] new_version
        #   If given a new version String, it will set the class'es version
        #   string.
        #
        # @return [String, nil]
        #   The classes version string.
        #
        def version(new_version=nil)
          if new_version
            @version = new_version
          else
            @version || (superclass.version if superclass.kind_of?(ClassMethods))
          end
        end
      end

      #
      # @see ClassMethods#version
      #
      def version
        self.class.version
      end

      #
      # Prints the version.
      #
      def print_version
        puts "#{command_name} #{version}"
      end
    end
  end
end
