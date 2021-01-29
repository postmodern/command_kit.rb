# frozen_string_literal: true

module CommandKit
  module Help
    #
    # Allows displaying a man-page instead of the usual `--help` output.
    #
    module Man
      #
      # Extends {ClassMethods}.
      #
      def self.included(base)
        base.extend ClassMethods
      end

      #
      # Defines class-level methods.
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
        #   man_dir File.expand_path('../../../man',__FILE__)
        #
        def man_dir(new_man_dir=nil)
          if new_man_dir
            @man_dir = File.expand_path(new_man_dir)
          else
            @man_dir || (superclass.man_dir if superclass.include?(ClassMethods))
          end
        end
      end

      #
      # Returns the man-page file name for the given command name.
      #
      # @param [String] command
      #   The given command name.
      #
      # @return [String]
      #   The man-page file name.
      #
      def man_page(command=command_name)
        "#{command}.1"
      end

      #
      # Displays the given man page.
      #
      # @param [String] page
      #   The man page file name.
      #
      # @return [Boolean]
      #   Specifies whether the `man` command was successful or not.
      #
      def man(page=man_page)
        system('man',page)
      end

      #
      # Displays the {#man_page} instead of the usual `--help` output.
      #
      # @raise [NotImplementedError]
      #   {ClassMethods#man_dir man_dir} does not have a value.
      #
      # @note
      #   if `TERM` is `dumb` or `$stdout` is not a TTY, fallsback to printing
      #   the usual `--help` output.
      #
      def help
        if ENV['TERM'] != 'dumb' && $stdout.tty?
          unless self.class.man_dir
            raise(NotImplementedError,"#{self.class}.man_dir not set")
          end

          if man(File.join(self.class.man_dir,man_page)).nil?
            super
          end
        else
          super
        end
      end
    end
  end
end
