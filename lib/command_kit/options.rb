require 'command_kit/options/option'
require 'command_kit/opt_parser'

module CommandKit
  #
  # Provides a thin DSL for defining options as attributes.
  #
  #     include CommandKit::Options
  #     
  #     option :foo, type: String,
  #                  short: '-f',
  #                  desc: "Foo option"
  #     
  #     option :bar, type: String,
  #                  short: '-b',
  #                  usage: 'STR:STR:...',
  #                  desc: "Bar option" do |arg|
  #       @bar = arg.split(':')
  #     end
  #     
  #     option :number, type: Integer,
  #                     desc: 'Numbers' do |num|
  #       @numbers << num
  #     end
  #     
  #     def initialize
  #       super
  #     
  #       @numbers = []
  #     end
  #
  module Options
    #
    # Includes {OptParser} and extends {ClassMethods}.
    #
    # @param [Class] command
    #   The command class which is including {Options}.
    #
    def self.included(command)
      command.include OptParser
      command.extend ClassMethods
    end

    #
    # Defines class-level methods.
    #
    module ClassMethods
      #
      # All defined options for the command class.
      #
      # @return [Hash{Symbol => Option}]
      #
      def options
        @options ||= if superclass.include?(ClassMethods)
                       superclass.options.dup
                     else
                       {}
                     end
      end

      #
      # Defines an {Option option} for the class.
      #
      # @param [Symbol] name
      #   The option name.
      #
      # @return [Option]
      #
      def option(name,**kwargs)
        options[name] = Option.new(name,**kwargs)
      end
    end

    # Hash of parsed option values.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    #
    # Initializes {#options} and populates the {OptParser#opts option parser}.
    #
    def initialize
      super

      @options = {}

      self.class.options.each_value do |option|
        opts.on(*option.usage,*option.type,option.desc) do |arg|
          @options[option.name] = arg

          option.block.call(arg) if option.block
        end
      end
    end
  end
end
