# command_kit

* [Homepage](https://github.com/postmodern/command_kit.rb#readme)
* [Forum](https://github.com/postmodern/command_kit.rb/discussions)
* [Issues](https://github.com/postmodern/command_kit.rb/issues)
* [Documentation](http://rubydoc.info/gems/command_kit/frames)

## Description

A Ruby toolkit for building clean, correct, and robust CLI commands as
plain-old Ruby classes.

## Features

* Supports defining commands as Classes.
* Supports defining options and arguments as attributes.
* Supports extending commands via inheritance.
* Supports subcommands (explicit or lazy-loaded) and command aliases.
* Correctly handles Ctrl^C and SIGINT interrupts (aka exit 130).
* Correctly handles broken pipes (aka `mycmd | head`).
* Correctly handles when stdout or stdin is redirected to a file.
* Uses [OptionParser][optparse] for POSIX option parsing.
* Supports optionally displaying a man-page instead of `--help`
  (see {CommandKit::Help::Man}).
* Supports optional ANSI coloring.
* Supports interactively prompting for user input.
* Supports easily detecting the terminal size.
* Supports paging output with `less` or `more`.
* Supports XDG directories (`~/.config/`, `~/.local/share/`, `~/.cache/`).
* Easy to test (ex: `MyCmd.main(arg1, arg2, options: {foo: foo}) # => 0`)

### API

* [CommandKit::Arguments](https://rubydoc.info/gems/command_kit/CommandKit/Arguments)
* [CommandKit::Colors](https://rubydoc.info/gems/command_kit/CommandKit/Colors)
* [CommandKit::Command](https://rubydoc.info/gems/command_kit/CommandKit/Command)
* [CommandKit::CommandName](https://rubydoc.info/gems/command_kit/CommandKit/CommandName)
* [CommandKit::Commands](https://rubydoc.info/gems/command_kit/CommandKit/Commands)
  * [CommandKit::Commands::AutoLoad](https://rubydoc.info/gems/command_kit/CommandKit/Commands/AutoLoad)
  * [CommandKit::Commands::AutoRequire](https://rubydoc.info/gems/command_kit/CommandKit/Commands/AutoRequire)
* [CommandKit::Description](https://rubydoc.info/gems/command_kit/CommandKit/Description)
* [CommandKit::Env](https://rubydoc.info/gems/command_kit/CommandKit/Env)
  * [CommandKit::Env::Home](https://rubydoc.info/gems/command_kit/CommandKit/Env/Home)
  * [CommandKit::Env::Path](https://rubydoc.info/gems/command_kit/CommandKit/Env/Path)
* [CommandKit::Examples](https://rubydoc.info/gems/command_kit/CommandKit/Examples)
* [CommandKit::ExceptionHandler](https://rubydoc.info/gems/command_kit/CommandKit/ExceptionHandler)
* [CommandKit::Help](https://rubydoc.info/gems/command_kit/CommandKit/Help)
  * [CommandKit::Help::Man](https://rubydoc.info/gems/command_kit/CommandKit/Help/Man)
* [CommandKit::Interactive](https://rubydoc.info/gems/command_kit/CommandKit/Interactive)
* [CommandKit::Main](https://rubydoc.info/gems/command_kit/CommandKit/Main)
* [CommandKit::Options](https://rubydoc.info/gems/command_kit/CommandKit/Options)
  * [CommandKit::Options::Quiet](https://rubydoc.info/gems/command_kit/CommandKit/Options/Quiet)
  * [CommandKit::Options::Verbose](https://rubydoc.info/gems/command_kit/CommandKit/Options/Verbose)
* [CommandKit::OS](https://rubydoc.info/gems/command_kit/CommandKit/OS)
* [CommandKit::Pager](https://rubydoc.info/gems/command_kit/CommandKit/Pager)
* [CommandKit::Printing](https://rubydoc.info/gems/command_kit/CommandKit/Printing)
  * [CommandKit::Printing::Indent](https://rubydoc.info/gems/command_kit/CommandKit/Printing/Indent)
* [CommandKit::ProgramName](https://rubydoc.info/gems/command_kit/CommandKit/ProgramName)
* [CommandKit::Stdio](https://rubydoc.info/gems/command_kit/CommandKit/Stdio)
* [CommandKit::Terminal](https://rubydoc.info/gems/command_kit/CommandKit/Terminal)
* [CommandKit::Usage](https://rubydoc.info/gems/command_kit/CommandKit/Usage)
* [CommandKit::XDG](https://rubydoc.info/gems/command_kit/CommandKit/XDG)

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
    
          argument :file, required: true,
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
