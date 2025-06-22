# frozen_string_literal: true

require_relative 'arguments'
require_relative 'options/option'
require_relative 'options/parser'

module CommandKit
  #
  # Provides a thin DSL for defining options as attributes.
  #
  # ## Examples
  #
  #     include CommandKit::Options
  #     
  #     option :foo, short: '-f',
  #                  value: {type: String},
  #                  desc:  "Foo option"
  #     
  #     option :bar, short: '-b',
  #                  value: {
  #                    type:  String,
  #                    usage: 'STR:STR:...'
  #                  },
  #                  desc: "Bar option" do |arg|
  #       @bar = arg.split(':')
  #     end
  #
  # ### Multi-line Descriptions
  #
  #     option :opt, value: {type: String},
  #                  desc: [
  #                          'line1',
  #                          'line2',
  #                          '...'
  #                        ]
  #
  # ### Option Categories
  #
  #     option :opt1, value: {type: String},
  #                   category: 'Foo Category',
  #                   desc: 'Option 1'
  #
  #     option :opt2, value: {type: String},
  #                   category: 'Foo Category',
  #                   desc: 'Option 2'
  #
  # ### initialize and using instance variables
  #     
  #     option :number, value: {type: Integer},
  #                     desc: 'Numbers' do |num|
  #       @numbers << num
  #     end
  #     
  #     def initialize(**kwargs)
  #       super(**kwargs)
  #     
  #       @numbers = []
  #     end
  #
  module Options
    include Arguments
    include Parser

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
      # All defined options for the command class.
      #
      # @return [Hash{Symbol => Option}]
      #
      # @api semipublic
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
      # @param [Hash{Symbol => Object}] kwargs
      #   Keyword arguments.
      #
      # @option kwargs [String, nil] short
      #   Optional short-flag for the option.
      #
      # @option kwargs [String, nil] long
      #   Optional explicit long-flag for the option.
      #
      # @option kwargs [Boolean] equals
      #   Specifies whether the option is of the form (`--opt=value`).
      #
      # @option kwargs [Hash{Symbol => Object}, true, false, nil] value
      #   Keyword arguments for {OptionValue#initialize}, or `nil` if the option
      #   has no additional value.
      #
      # @option value [Class, Hash, Array, Regexp] type
      #   The type of the option's value.
      #
      # @option value [String, nil] usage
      #   The usage string for the option's value.
      #
      # @option kwargs [String, Array<String>] desc
      #   The description for the option.
      #
      # @option kwargs [String, nil] category
      #   The optional category to group the option under.
      #
      # @yield [(value)]
      #   If a block is given, it will be passed the parsed option value.
      #
      # @yieldparam [Object, nil] value
      #   The parsed option value.
      #
      # @return [Option]
      #
      # @raise [TypeError]
      #   The `value` keyword argument was not a `Hash`, `true`, `false`, or
      #   `nil`.
      #
      # @example Define an option:
      #     option :foo, desc: "Foo option"
      #
      # @example Define an option with a multi-line description:
      #     option :foo, desc: [
      #                          "Line 1",
      #                          "Line 2"
      #                        ]
      #
      # @example Defines multiple options within a category:
      #     option :foo, desc: "Foo option",
      #                  category: 'Other Options'
      #     
      #     option :bar, desc: "Bar option",
      #                  category: 'Other Options'
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
      # @api public
      #
      def option(name,**kwargs,&block)
        options[name] = Option.new(name,**kwargs,&block)
      end
    end

    # Hash of parsed option values.
    #
    # @return [Hash{Symbol => Object}]
    #
    # @api semipublic
    #
    attr_reader :options

    #
    # Initializes {#options} and populates the
    # {Parser#option_parser option parser}.
    #
    # @param [Hash{Symbol => Object}] options
    #   Optional prepopulated options hash.
    #
    # @note
    #   The {#option_parser} will populate {#options} and also call any
    #   {ClassMethods#option option} blocks with the parsed option values.
    #
    # @api public
    #
    def initialize(options: {}, **kwargs)
      @options = options

      super(**kwargs)

      define_option_categories()
    end

    #
    # Overrides the default {Usage#help help} method and calls {#help_options}
    # and {#help_arguments}.
    #
    # @api public
    #
    def help
      help_options
      help_arguments
    end

    private

    #
    # Defines all of the options, grouped by category.
    #
    def define_option_categories
      categories = self.class.options.values.group_by(&:category)

      categories.each do |category,options|
        if category
          define_options_category(category,options)
        end
      end

      define_options_category('Options',categories.fetch(nil,[]))
    end

    #
    # Defines a new category of options with a header.
    #
    # @param [String] category
    #   The category name.
    #
    # @param [Array<Option>, nil] options
    #   The options to define.
    #
    def define_options_category(category,options)
      option_parser.separator ''
      option_parser.separator "#{category}:"

      options.each(&method(:define_option))
    end

    #
    # Defines an individual option.
    #
    # @param [Option] option
    #
    def define_option(option)
      unless (default_value = option.default_value).nil?
        @options[option.name] = default_value
      end

      option_parser.on(*option.usage,option.type,*option.desc) do |value|
        if option.type.is_a?(Regexp) && value.is_a?(Array)
          # separate the optiona value from the additional Regexp captures
          value, *args = value
        else
          args = nil
        end

        @options[option.name] = value
        instance_exec(value,*args,&option.block) if option.block
      end
    end
  end
end
