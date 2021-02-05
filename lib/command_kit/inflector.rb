# frozen_string_literal: true

module CommandKit
  #
  # A very simple inflector.
  #
  # @note
  #   If you need something more powerful, checkout
  #   [dry-inflector](https://dry-rb.org/gems/dry-inflector/0.1/)
  #
  module Inflector
    #
    # Removes the namespace from a constant name.
    #
    # @param [#to_s] name
    #   The constant name.
    #
    # @return [String]
    #   The class or module's name, without the namespace.
    #
    def self.demodularize(name)
      name.to_s.split('::').last
    end

    #
    # Converts a CamelCased name to an under_scored name.
    #
    # @param [#to_s] name
    #   The CamelCased name.
    #
    # @return [String]
    #   The resulting under_scored name.
    #
    def self.underscore(name)
      # sourced from: https://github.com/dry-rb/dry-inflector/blob/c918f967ff82611da374eb0847a77b7e012d3fa8/lib/dry/inflector.rb#L286-L287
      name = name.to_s.dup

      name.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      name.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      name.downcase!

      name
    end

    #
    # Replaces all underscores with dashes.
    #
    # @param [#to_s] name
    #   The under_scored name.
    #
    # @return [String]
    #   The dasherized name.
    #
    def self.dasherize(name)
      name.to_s.tr('_','-')
    end

    #
    # Converts an under_scored name to a CamelCased name.
    #
    # @param [String] name
    #   The under_scored name.
    #
    # @return [String]
    #   The CamelCased name.
    #
    def self.camelize(name)
      name = name.to_s.dup

      # sourced from: https://github.com/dry-rb/dry-inflector/blob/c918f967ff82611da374eb0847a77b7e012d3fa8/lib/dry/inflector.rb#L329-L334
      name.sub!(/^[a-z\d]*/,&:capitalize)
      name.gsub!(%r{(?:_|(/))([a-z\d]*)}i) do |match|
        m1 = Regexp.last_match(1)
        m2 = Regexp.last_match(2)

        "#{m1}#{m2.capitalize}"
      end

      name
    end
  end
end
