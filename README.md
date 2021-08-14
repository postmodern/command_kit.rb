# command_kit

[![Build Status](https://github.com/postmodern/command_kit.rb/workflows/CI/badge.svg?branch=main)](https://github.com/postmodern/command_kit.rb/actions)

A Ruby toolkit for building clean, correct, and robust CLI commands as
plain-old Ruby classes.

* [Homepage](https://github.com/postmodern/command_kit.rb#readme)
* [Forum](https://github.com/postmodern/command_kit.rb/discussions) | [Issues](https://github.com/postmodern/command_kit.rb/issues)
* [Documentation](http://rubydoc.info/gems/command_kit/frames)

## Features

* **Simplicity** - Commands are plain-old ruby classes, with options and arguments as attributes. Extend commands via inheritance. Uses [OptionParser][optparse] for POSIX option parsing.
* **Subcommands** - Supports subcommands (explicit or lazy-loaded) and command aliases.
* **Signals and errors** - Handles Ctrl^C and SIGINT interrupts (aka exit 130). Handles broken pipes (aka `mycmd | head`).
* **Integration** - Optional ANSI coloring. Interactive prompt for user input. Supports easily detecting the terminal size, and paging output with `less` or `more`. Supports [XDG directories](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) (`~/.config/`, `~/.local/share/`, `~/.cache/`).
* **Redirects** - Correctly handles when stdout or stdin is redirected to a file.
* **Man** - Display a man-page instead of `--help` (see {CommandKit::Help::Man}).
* **Testability** - Easy to test (ex: `MyCmd.main(arg1, arg2, options: {foo: foo}) # => 0`)

## Anti-Features

* No additional runtime dependencies.
* Does not implement it's own option parser.
* Not named after a comic-book Superhero.

## Install

```sh
# install gem
$ gem install command_kit

# or add to your Gemfile
gem 'command_kit', '~> 0.2'
```

## Example

### lib/foo/cli/my_cmd.rb

```ruby
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
```

### bin/my_cmd

```ruby
#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
require 'foo/cli/my_cmd'

Foo::CLI::MyCmd.start
```

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

## Alternatives

* [dry-cli](https://dry-rb.org/gems/dry-cli/0.6/)
* [cmdparse](https://cmdparse.gettalong.org/)

## Special Thanks

Special thanks to everyone who answered my questions and gave feedback on
Twitter.

### Reference

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
* [CommandKit::Pager](https://rubydoc.info/gems/command_kit/CommandKit/Pager)
* [CommandKit::Printing](https://rubydoc.info/gems/command_kit/CommandKit/Printing)
  * [CommandKit::Printing::Indent](https://rubydoc.info/gems/command_kit/CommandKit/Printing/Indent)
* [CommandKit::ProgramName](https://rubydoc.info/gems/command_kit/CommandKit/ProgramName)
* [CommandKit::Stdio](https://rubydoc.info/gems/command_kit/CommandKit/Stdio)
* [CommandKit::Terminal](https://rubydoc.info/gems/command_kit/CommandKit/Terminal)
* [CommandKit::Usage](https://rubydoc.info/gems/command_kit/CommandKit/Usage)
* [CommandKit::XDG](https://rubydoc.info/gems/command_kit/CommandKit/XDG)

## Copyright

Copyright (c) 2021 Hal Brodigan

See {file:LICENSE.txt} for details.

[ruby]: https://www.ruby-lang.org/
[optparse]: https://rubydoc.info/stdlib/optparse/OptionParser
