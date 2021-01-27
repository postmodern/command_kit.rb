# command_kit

* [Homepage](https://github.com/postmodern/command_kit#readme)
* [Issues](https://github.com/postmodern/command_kit/issues)
* [Documentation](http://rubydoc.info/gems/command_kit/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

A Ruby toolkit for building clean, correct, and robust CLI commands as Ruby
classes.

## Features

* Supports defining commands as Classes.
* Supports defining options and arguments as attributes.
* Correctly handles Ctrl^C and SIGINT interrupts (aka exit 130).
* Correctly handles broken pipes (aka quitting `mycmd | less`).
* Provides a simple DSL around [OptionParser][optparse].
* Provides ANSI coloring support.
* Supports optionally displaying a man-page instead of `--help`
  (see {CommandKit::Help::Man}).
* Easy to test (just call `MyCmd.run('--foo', foo, ...)`).

## Anti-Features

* No additional runtime dependencies.
* Does not implement it's own option parser.
* Not named after a comic-book Superhero.

## Examples

### lib/foo/my_cmd.rb

    require 'command_kit'

    module Foo
      module CLI
        class MyCmd < CommandKit::Command
    
          usage 'mycmd [OPTIONS] [-o OUTPUT] FILE'
    
          option :count, type: Integer,
                         default: 1,
                         short: '-c',
                         desc: "Number of times"
    
          option :output, type: String,
                          usage: 'FILE',
                          short: '-o',
                          desc: "Optional output file"
    
          option :verbose, short: '-v', desc: "Increase verbose level" do
            @verbose += 1
          end
    
          argument :file, type: String,
                          required: true,
                          usage: 'FILE',
                          desc: "Input file"
    
          def initialize
            super
    
            @verbose = 0
          end
    
          def main(file)
            # ...
          end
    
        end
      end
    end

### bin/mycmd

    require 'foo/cli/my_cmd'
    Foo::CLI::MyCmd.start

## Requirements

* [ruby] >= 2.0.0

## Install

    $ gem install command_kit

### Gemfile

    gem 'command_kit', '~> 0.1'

## Copyright

Copyright (c) 2021 Hal Brodigan

See {file:LICENSE.txt} for details.

[ruby]: https://www.ruby-lang.org/
[optparse]: https://rubydoc.info/stdlib/optparse/OptionParser
