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
* Uses [OptionParser][optparse] for option parsing.
* Provides ANSI coloring support.
* Supports optionally displaying a man-page instead of `--help`
  (see {CommandKit::Help::Man}).
* Supports XDG directories (`~/.config/`, `~/.local/share/`, `~/.cache/`).
* Easy to test:
  * `MyCmd.main(arg1, arg2, options: {foo: foo}) # => 0`

### Modules

* {CommandKit::ANSI}
* {CommandKit::Arguments}
* {CommandKit::Backtrace}
* {CommandKit::CommandName}
* {CommandKit::Description}
* {CommandKit::Env}
  * {CommandKit::Env::Home}
* {CommandKit::Examples}
* {CommandKit::Exit}
* {CommandKit::Help}
  * {CommandKit::Help::Man}
* {CommandKit::Main}
* {CommandKit::Options}
  * {CommandKit::Options::Quiet}
  * {CommandKit::Options::Verbose}
* {CommandKit::Printing}
* {CommandKit::ProgramName}
* {CommandKit::Stdio}
* {CommandKit::Usage}
* {CommandKit::XDG}

## Anti-Features

* No additional runtime dependencies.
* Does not implement it's own option parser.
* Not named after a comic-book Superhero.

## Examples

### Command

#### lib/foo/cli/my_cmd.rb

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

#### bin/my_cmd

    #!/usr/bin/env ruby
    
    $LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
    require 'foo/cli/my_cmd'
    
    Foo::CLI::MyCmd.start

#### --help

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

### Options

Define an option:

    option :foo, desc: "Foo option"

With a custom short option:

    option :foo, short: '-f',
                 desc: "Foo option"

With a custom long option:

    option :foo, short: '--foo-opt',
                 desc: "Foo option"

With a custom usage string:

    option :foo, value: {usage: 'FOO'},
                 desc: "Foo option"

With a custom block:

    option :foo, desc: "Foo option" do |value|
      @foo = Foo.new(value)
    end

With a custom type:

    option :foo, value: {type: Integer},
                 desc: "Foo option"

With a default value:

    option :foo, value: {type: Integer, default: 1},
                 desc: "Foo option"

With a required value:

    option :foo, value: {type: String, required: true},
                 desc: "Foo option"

With a custom option value Hash map:

    option :flag, value: {
                    type: {
                      'enabled'  => :enabled,
                      'yes'      => :enabled,
                      'disabled' => :disabled,
                      'no'       => :disabled
                    }
                  },
                  desc: "Flag option"

With a custom option value Array enum:

    option :enum, value: {type: %w[yes no]},
                  desc: "Enum option"

With a custom option value Regexp:

    option :date, value: {type: /(\d+)-(\d+)-(\d{2,4})/},
                  desc: "Regexp optin" do |date,d,m,y|
      # ...
    end

### Arguments

Define an argument:

    argument :bar, desc: "Bar argument"

With a custom usage string:

    option :bar, usage: 'BAR',
                 desc: "Bar argument"

With a custom block:

    argument :bar, desc: "Bar argument" do |bar|
      # ...
    end

With a custom type:

    argument :bar, type: Integer,
                   desc: "Bar argument"

With a default value:

    argument :bar, default: "bar.txt",
                   desc: "Bar argument"

An optional argument:

    argument :bar, required: true,
                   desc: "Bar argument"

A repeating argument:

    argument :bar, repeats: true,
                   desc: "Bar argument"

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
