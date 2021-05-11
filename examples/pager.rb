#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
require 'command_kit/command'
require 'command_kit/pager'

class PagerCmd < CommandKit::Command

  include CommandKit::Pager

  description "Demos using the pager"

  def run
    puts "Starting pager ..."

    pager do |io|
      10.times do |i|
        io.puts i
        sleep 0.5
      end
    end

    puts "Exiting pager ..."
  end

end

if __FILE__ == $0
  PagerCmd.start
end
