# frozen_string_literal: true

require_relative '../options'

module CommandKit
  module Options
    #
    # Defines a version option.
    #
    # ## Examples
    #
    #     include CommandKit::Options::Version
    #     
    #     version '0.1.0'
    #     
    #     def run(*argv)
    #       # ...
    #     end
    #
    module Version
      #
      # Includes {Options}, extends {Version::ClassMethods}, and defines a
      # `-V, --version` option.
      #
      def self.included(command)
        command.include Options
        command.extend ClassMethods

        command.option :version, short: '-V',
                                 desc: 'Prints the version and exits' do
          print_version
          exit(0)
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
        # @api public
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
      # @api public
      #
      def version
        self.class.version
      end

      #
      # Prints the version.
      #
      # @api public
      #
      def print_version
        puts "#{command_name} #{version}"
      end
    end
  end
end
