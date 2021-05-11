#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
require 'command_kit/command'
require 'command_kit/colors'

class ColorsCmd < CommandKit::Command

  include CommandKit::Colors

  description "Prints all of the standard ANSI colors"

  def run
    colors do |c|
      puts c.black("Black")     + "\t" + c.bold(c.black("Bold"))
      puts c.red("Red")         + "\t" + c.bold(c.red("Bold"))
      puts c.green("Green")     + "\t" + c.bold(c.green("Bold"))
      puts c.yellow("Yellow")   + "\t" + c.bold(c.yellow("Bold"))
      puts c.blue("Blue")       + "\t" + c.bold(c.blue("Bold"))
      puts c.magenta("Magenta") + "\t" + c.bold(c.magenta("Bold"))
      puts c.cyan("Cyan")       + "\t" + c.bold(c.cyan("Bold"))
      puts c.cyan("White")      + "\t" + c.bold(c.white("Bold"))
    end
  end

end

if __FILE__ == $0
  ColorsCmd.start
end
