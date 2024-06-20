#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
require 'command_kit/command'
require 'command_kit/interactive'

class InteractiveCmd < CommandKit::Command

  include CommandKit::Interactive

  description 'Demonstrates interactive prompt input'

  def run
    you_entered = ->(result) {
      puts "You entered: #{result.inspect}"
      puts
    }

    you_entered[ask("Single-line input")]
    you_entered[ask_secret("Secret input")]
    you_entered[ask_yes_or_no("Yes or no prompt")]
    you_entered[ask_multiple_choice("Multiple choice", %w[Red Green Blue])]
    you_entered[ask_multiline('Multi-line comment 1')]
  end

end

if __FILE__ == $0
  InteractiveCmd.start
end
