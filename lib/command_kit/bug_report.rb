require_relative 'exception_handler'
require_relative 'printing'

module CommandKit
  #
  # Adds an exception handler to print a bug report when an unhandled exception
  # is raised by `run`.
  #
  # @since 0.4.0
  #
  module BugReport
    include ExceptionHandler
    include Printing

    #
    # @api private
    #
    module ModuleMethods
      #
      # Extends {ClassMethods} or {ModuleMethods}, depending on whether
      # {Options} is being included into a class or a module.
      #
      # @param [Class, Module] context
      #   The class or module which is including {Options}.
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
    # Defines class-level methods.
    #
    module ClassMethods
      #
      # Gets or sets the bug report URL.
      #
      # @param [String, nil] new_url
      #   The new bug report URL.
      #
      # @return [String, nil]
      #   The bug report URL.
      #
      # @example
      #   bug_report_url 'https://github.com/user/repo/issues/new'
      #
      def bug_report_url(new_url=nil)
        if new_url
          @bug_report_url = new_url
        else
          @bug_report_url || if superclass.kind_of?(ClassMethods)
                               superclass.bug_report_url
                             end
        end
      end
    end

    #
    # The bug report URL.
    #
    # @return [String, nil]
    #
    def bug_report_url
      self.class.bug_report_url
    end

    #
    # Overrides {#on_exception} to print a bug report for unhandled exceptions
    # and then exit with `-1`.
    #
    # @param [Exception] error
    #   The unhandled exception.
    #
    def on_exception(error)
      print_bug_report(error)
      exit(-1)
    end

    #
    # Prints a bug report for the unhandled exception.
    #
    # @param [Exception] error
    #   The unhandled exception.
    #
    def print_bug_report(error)
      url = bug_report_url

      stderr.puts
      stderr.puts "Oops! Looks like you have found a bug. Please report it!"
      stderr.puts url if url
      stderr.puts
      stderr.puts '```'
      print_exception(error)
      stderr.puts '```'
    end
  end
end
