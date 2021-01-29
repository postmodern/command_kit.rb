require 'command_kit/options/option'
require 'command_kit/options/parser'

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
    # Includes {Parser} and extends {ClassMethods}.
    #
    # @param [Class] command
    #   The command class which is including {Options}.
    #
    def self.included(command)
      command.include Parser
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
      # @yield [(value)]
      #   If a block is given, it will be passed the parsed option value.
      #
      # @yieldparam [Object, nil] value
      #   The parsed option value.
      #
      # @return [Option]
      #
      def option(name,**kwargs,&block)
        options[name] = Option.new(name,**kwargs,&block)
      end
    end

    # Hash of parsed option values.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    #
    # Initializes {#options} and populates the
    # {Parser#option_parser option parser}.
    #
    def initialize
      super

      @options = {}

      self.class.options.each_value do |option|
        option_parser.on(*option.usage,*option.type,option.desc) do |arg,*captures|
          @options[option.name] = if arg.nil?
                                    option.default_value
                                  else
                                    arg
                                  end

          if option.block
            instance_exec(*arg,*captures,&option.block)
          end
        end
      end
    end
  end
end
