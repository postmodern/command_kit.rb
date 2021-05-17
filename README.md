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
* Supports subcommands (explicit or lazy-loaded) and command aliases.
* Correctly handles Ctrl^C and SIGINT interrupts (aka exit 130).
* Correctly handles broken pipes (aka `mycmd | head`).
* Uses [OptionParser][optparse] for option parsing.
* Provides ANSI coloring support.
* Supports optionally displaying a man-page instead of `--help`
  (see {CommandKit::Help::Man}).
* Supports XDG directories (`~/.config/`, `~/.local/share/`, `~/.cache/`).
* Easy to test:
  * `MyCmd.main(arg1, arg2, options: {foo: foo}) # => 0`

### API

* [CommandKit::Arguments](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Arguments)
* [CommandKit::Colors](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Colors)
* [CommandKit::Command](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Command)
* [CommandKit::CommandName](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/CommandName)
* [CommandKit::Commands](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Commands)
  * [CommandKit::Commands::AutoLoad](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Commands/AutoLoad)
  * [CommandKit::Commands::AutoRequire](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Commands/AutoRequire)
* [CommandKit::Console](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Console)
* [CommandKit::Description](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Description)
* [CommandKit::Env](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Env)
  * [CommandKit::Env::Home](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Env/Home)
  * [CommandKit::Env::Path](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Env/Path)
* [CommandKit::Examples](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Examples)
* [CommandKit::ExceptionHandler](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/ExceptionHandler)
* [CommandKit::Help](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Help)
  * [CommandKit::Help::Man](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Help/Man)
* [CommandKit::Main](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Main)
* [CommandKit::Options](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Options)
  * [CommandKit::Options::Quiet](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Options/Quiet)
  * [CommandKit::Options::Verbose](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Options/Verbose)
* [CommandKit::Pager](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Pager)
* [CommandKit::Printing](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Printing)
  * [CommandKit::Printing::Indent](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Printing/Indent)
* [CommandKit::ProgramName](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/ProgramName)
* [CommandKit::Stdio](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Stdio)
* [CommandKit::Usage](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/Usage)
* [CommandKit::XDG](https://rubydoc.info/github/postmodern/command_kit/main/CommandKit/XDG)

## Anti-Features

* No additional runtime dependencies.
* Does not implement it's own option parser.
* Not named after a comic-book Superhero.

## Examples

### lib/foo/cli/my_cmd.rb

    require 'command_kit'

    module Foo
      module CLI
        class MyCmd < CommandKit::Command
    
          usage '[OPTIONS] [-o OUTPUT] FILE'
    
          option :count, short: '-c',
                         value: {
                           type: Integer,
                           default: 1
                         },
                         desc: "Number of times"
    
          option :output, short: '-o',
                          value: {
                            type: String,
                            usage: 'FILE'
                          },
                          desc: "Optional output file"
    
          option :verbose, short: '-v', desc: "Increase verbose level" do
            @verbose += 1
          end
    
          argument :file, type: String,
                          required: true,
                          usage: 'FILE',
                          desc: "Input file"

          examples [
            '-o path/to/output.txt path/to/input.txt',
            '-v -c 2 -o path/to/output.txt path/to/input.txt',
          ]

          description 'Example command'
    
          def initialize(**kwargs)
            super(**kwargs)
    
            @verbose = 0
          end
    
          def run(file)
            puts "count=#{options[:count].inspect}"
            puts "output=#{options[:output].inspect}"
            puts "file=#{file.inspect}"
            puts "verbose=#{@verbose.inspect}"
          end
    
        end
      end
    end

### bin/my_cmd

    #!/usr/bin/env ruby
    
    $LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
    require 'foo/cli/my_cmd'
    
    Foo::CLI::MyCmd.start

### --help

    Usage: my_cmd [OPTIONS] [-o OUTPUT] FILE
    
    Options:
        -c, --count INT                  Number of times (Default: 1)
        -o, --output FILE                Optional output file
        -v, --verbose                    Increase verbose level
        -h, --help                       Print help information
    
    Arguments:
        FILE                             Input file
    
    Examples:
        my_cmd -o path/to/output.txt path/to/input.txt
        my_cmd -v -c 2 -o path/to/output.txt path/to/input.txt
    
    Example command

## Requirements

* [ruby] >= 2.7.0

## Install

    $ gem install command_kit

### Gemfile

    gem 'command_kit', '~> 0.1'

## Alternatives

* [dry-cli](https://dry-rb.org/gems/dry-cli/0.6/)
* [cmdparse](https://cmdparse.gettalong.org/)

## Special Thanks

Special thanks to everyone who answered my questions and gave feedback on
Twitter.

## Copyright

Copyright (c) 2021 Hal Brodigan

See {file:LICENSE.txt} for details.

[ruby]: https://www.ruby-lang.org/
[optparse]: https://rubydoc.info/stdlib/optparse/OptionParser
