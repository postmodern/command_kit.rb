# frozen_string_literal: true

require 'command_kit/env'

module CommandKit
  module Env
    #
    # Provides access to the `HOME` environment variable.
    #
    # ## Environment Variables
    #
    # * `HOME` - The absolute path to the user's home directory.
    #
    module Home
      include Env

      #
      # @api private
      #
      module ModuleMethods
        #
        # Extends {ClassMethods} or {ModuleMethods}, depending on whether
        # {Env::Home} is being included into a class or a module..
        #
        # @param [Class, Module] context
        #   The class or module which is including {Home}.
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
        #
        # The default home directory.
        #
        # @return [String]
        #
        # @api semipublic
        #
        def home_dir
          Gem.user_home
        end
      end

      # The home directory.
      #
      # @return [String]
      #
      # @api public
      attr_reader :home_dir

      #
      # Initializes {#home_dir} to either `env['HOME']` or
      # {ClassMethods#home_dir self.class.home_dir}.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      # @api public
      #
      def initialize(**kwargs)
        super(**kwargs)

        @home_dir = env.fetch('HOME') { self.class.home_dir }
      end
    end
  end
end
