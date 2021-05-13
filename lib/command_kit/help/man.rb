# frozen_string_literal: true

require 'command_kit/command_name'
require 'command_kit/help'
require 'command_kit/stdio'

module CommandKit
  module Help
    #
    # Allows displaying a man-page instead of the usual `--help` output.
    #
    # ## Examples
    #
    #     class Foo < CommandKit::Command
    #
    #       include CommandKit::Help::Man
    #
    #       man_dir "#{__dir__}/../../man"
    #
    #     end
    #
    # ## Environment Variables
    #
    # * `TERM` - Specifies the type of terminal. When set to `DUMB`, it will
    #   disable man-page help output.
    #
    module Man
      include CommandName
      include Help
      include Stdio

      module ModuleMethods
        #
        # Extends {ClassMethods} or {ModuleMethods}, depending on whether
        # {Help::Man} is being included into a class or a module.
        #
        # @param [Class, Module] context
        #   The class or module including {Man}.
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
        # Gets or sets the directory where man-pages are stored.
        #
        # @param [String, nil] new_man_dir
        #   If a String is given, it will set The class'es man-page directory.
        #
        # @return [String, nil]
        #   The class'es or superclass'es man-page directory.
        #
        # @example
        #   man_dir "#{__dir__}/../../man"
        #
        def man_dir(new_man_dir=nil)
          if new_man_dir
            @man_dir = new_man_dir
          else
            @man_dir || if superclass.kind_of?(ClassMethods)
                          superclass.man_dir
                        end
          end
        end

        #
        # Gets or sets the class'es man-page file name.
        #
        # @param [String, nil] new_man_page
        #   If a String is given, the class'es man-page file name will be set.
        #
        # @return [String]
        #   The class'es or superclass'es man-page file name.
        #
        def man_page(new_man_page=nil)
          if new_man_page
            @man_page = new_man_page
          else
            @man_page || "#{command_name}.1"
          end
        end
      end

      #
      # Displays the given man page.
      #
      # @param [String] page
      #   The man page file name.
      #
      # @param [Integer, String, nil] section
      #   The optional section number to specify.
      #
      # @return [Boolean, nil]
      #   Specifies whether the `man` command was successful or not.
      #   Returns `nil` when the `man` command is not installed.
      #
      def man(page, section: nil)
        if section
          system('man',section.to_s,page)
        else
          system('man',page)
        end
      end

      #
      # Provides help information by showing one of the man pages within
      # {ClassMethods#man_dir .man_dir}.
      #
      # @param [String] man_page
      #   The file name of the man page to display.
      #
      # @return [Boolean, nil]
      #   Specifies whether the `man` command was successful or not.
      #   Returns `nil` when the `man` command is not installed.
      #
      # @raise [NotImplementedError]
      #   {ClassMethods#man_dir .man_dir} does not have a value.
      #
      def help_man(man_page=self.class.man_page)
        unless self.class.man_dir
          raise(NotImplementedError,"#{self.class}.man_dir not set")
        end

        man_path = File.join(self.class.man_dir,man_page)

        man(man_path)
      end

      #
      # Displays the {ClassMethods#man_page .man_page} in
      # {ClassMethods#man_dir .man_dir} instead of the usual `--help` output.
      #
      # @raise [NotImplementedError]
      #   {ClassMethods#man_dir .man_dir} does not have a value.
      #
      # @note
      #   if `TERM` is `dumb` or `$stdout` is not a TTY, fallsback to printing
      #   the usual `--help` output.
      #
      def help
        if stdout.tty?
          if help_man.nil?
            # the `man` command is not installed
            super
          end
        else
          super
        end
      end
    end
  end
end
