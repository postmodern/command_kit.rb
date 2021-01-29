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
      name.to_s.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2') \
               .gsub(/([a-z\d])([A-Z])/, '\1_\2') \
               .downcase
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
  end
end
