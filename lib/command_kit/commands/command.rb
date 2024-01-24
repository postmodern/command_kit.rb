# frozen_string_literal: true

require_relative '../command'
require_relative 'parent_command'

module CommandKit
  module Commands
    #
    # @api public
    #
    class Command < CommandKit::Command

      include ParentCommand

    end
  end
end
