require 'command_kit/options/option'
require 'command_kit/options/parser'

module CommandKit
  #
  # Provides a thin DSL for defining options as attributes.
  #
  # ## Examples
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
    include Parser

    module ModuleMethods
      #
      # Extends {ClassMethods}.
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
      # All defined options for the command class.
      #
      # @return [Hash{Symbol => Option}]
      #
      def options
        @options ||= if superclass.kind_of?(ClassMethods)
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
      # @example Define an option:
      #     option :foo, desc: "Foo option"
      #
      # @example With a custom short option:
      #     option :foo, short: '-f',
      #                  desc: "Foo option"
      #
      # @example With a custom long option:
      #     option :foo, short: '--foo-opt',
      #                  desc: "Foo option"
      #
      # @example With a custom usage string:
      #     option :foo, value: {usage: 'FOO'},
      #                  desc: "Foo option"
      #
      # @example With a custom block:
      #     option :foo, desc: "Foo option" do |value|
      #       @foo = Foo.new(value)
      #     end
      #
      # @example With a custom type:
      #     option :foo, value: {type: Integer},
      #                  desc: "Foo option"
      #
      # @example With a default value:
      #     option :foo, value: {type: Integer, default: 1},
      #                  desc: "Foo option"
      #
      # @example With a required value:
      #     option :foo, value: {type: String, required: true},
      #                  desc: "Foo option"
      #
      # @example With a custom option value Hash map:
      #     option :flag, value: {
      #                     type: {
      #                       'enabled'  => :enabled,
      #                       'yes'      => :enabled,
      #                       'disabled' => :disabled,
      #                       'no'       => :disabled
      #                     }
      #                   },
      #                   desc: "Flag option"
      #
      # @example With a custom option value Array enum:
      #     option :enum, value: {type: %w[yes no]},
      #                   desc: "Enum option"
      #
      # @example With a custom option value Regexp:
      #     option :date, value: {type: /(\d+)-(\d+)-(\d{2,4})/},
      #                   desc: "Regexp optin" do |date,d,m,y|
      #       # ...
      #     end
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
    # @param [Hash{Symbol => Object}] options
    #   Optional pre-populated options hash.
    #
    def initialize(options: {}, **kwargs)
      @options = options

      super(**kwargs)

      self.class.options.each_value do |option|
        option_parser.on(*option.usage,option.type,option.desc) do |arg,*captures|
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
