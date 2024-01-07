#!/usr/bin/env ruby

puts "Before require_relative '../lib/...':"
p $LOAD_PATH
require_relative '../lib/command_kit/command'
puts "After require_relative '../lib/...':"
p $LOAD_PATH

if defined?(Bundler) || !$LOADED_FEATURES.grep(/bundler/).empty?
  puts "Bundler was loaded!"
else
  puts "Bundler was not loaded"
end
puts

class Command < CommandKit::Command

  usage '[OPTIONS] [-o OUTPUT] FILE'

  option :count, short: '-c',
                 value: {
                   type: Integer,
                   default: 1
                 },
                 desc: "Number of times"

  option :output, value: {
                    type: String,
                    usage: 'FILE'
                  },
                  short: '-o',
                  desc: "Optional output file"

  option :verbose, short: '-v', desc: "Increase verbose level" do
    @verbose += 1
  end

  argument :file, required: true,
                  usage: 'FILE',
                  desc: "Input file"

  examples [
    '-o path/to/output.txt path/to/input.txt',
    '-v -c 2 -o path/to/output.txt path/to/input.txt'
  ]

  description "Example command"

  def initialize
    super

    @verbose = 0
  end

  def run(file)
    unless options.empty?
      puts "Options:"
      options.each do |name,value|
        puts "  #{name.inspect} => #{value.inspect}"
      end
      puts
    end

    puts "Arguments:"
    puts "  file = #{file.inspect}"
    puts

    puts "Custom Variables:"
    puts "  version = #{@verbose.inspect}"
  end
end

if __FILE__ == $0
  Command.start
end
