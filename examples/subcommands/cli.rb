#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../../lib',__FILE__))

require 'command_kit/commands'

require_relative './cli/config'
require_relative './cli/list'
require_relative './cli/update'

module Foo
  #
  # The main CLI command.
  #
  class CLI

    include CommandKit::Commands

    class << self
      # The global configuration file setting.
      #
      # @return [String, nil]
      attr_accessor :config_file
    end

    command_name 'foo'

    # Commands must be explicitly registered, unless
    # CommandKit::Commands::AutoLoad.new(...) is included.
    command Config
    command List
    command Update

    # Commands may have aliases
    command_aliases['ls'] = 'list'
    command_aliases['up'] = 'update'

    # Global options may be defined which are parsed before the sub-command's
    # options are parsed and the sub-command is executed.
    option :config_file, short: '-C',
                         value: {
                           type: String,
                           usage: 'FILE'
                         },
                         desc: 'Global option to set the config file' do |file|
                           CLI.config_file = file
                         end

  end
end

if $0 == __FILE__
  # Normally you would invoke Foo::CLI.start from a bin/ script.
  Foo::CLI.start
end
