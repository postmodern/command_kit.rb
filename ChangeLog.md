### 0.6.0 / 2024-06-19

* Added {CommandKit::Interactive#ask_multiline}.
* Added {CommandKit::Open}.
* Added {CommandKit::Options::VerboseLevel}.

### 0.5.6 / 2024-06-19

#### CommandKit::Inflector

* Fixed {CommandKit::Inflector.camelize} to convert `foo-1234-5678` to
  `Foo_1234_5678`.

#### CommandKit::Printing::Indent

* Micro-optimization to {CommandKit::Printing::Indent#puts}.

### 0.5.5 / 2024-04-08

#### CommandKit::Interactive

* Ensure that the interactive prompt is re-printed when no input is entered
  and input is required from the user.

#### CommandKit::Options

* Do not pass an Array of Regexp captures for an option's value Regexp type
  into an option's block, if the option's block only accepts one argument.
  Instead, only pass the option's value as a String.

### 0.5.4 / 2024-03-14

#### CommandKit::Options

* Fixed a bug where `Array` option values were only setting the option's value
  to the first element of the parsed `Array` value.

### 0.5.3 / 2024-03-12

#### CommandKit::Interactive

* Fixed {CommandKit::Interactive#ask} to remove the newline from the read user
  input.

### 0.5.2 / 2024-03-07

#### CommandKit::Options

* Fixed the `--help` output for options with multi-line descriptions
  (ex: `desc: ['Line 1', 'Line 2', ...]`).

### 0.5.1 / 2024-01-24

* Switched to using `require_relative` to improve load-times.
* Added `# frozen_string_literal: true` to all files.

### 0.5.0 / 2024-01-04

* Added {CommandKit::Env::Shell}.
* Added {CommandKit::Env::Prefix}.
* Added {CommandKit::Completion::Install}.

### 0.4.1 / 2024-01-03

* Added more examples of how to define sub-commands and sub-sub-commands.

#### CommandKit::Options::Parser

* Do not override the command's `usage` if it's already been set.

#### CommandKit::Printing::Tables

* Format the table output as UTF-8 to allow UTF-8 data in the formatted table.

### 0.4.0 / 2022-11-11

* Added {CommandKit::BugReport}.
* Added {CommandKit::Edit}.
* Added {CommandKit::Printing::Fields}.
* Added {CommandKit::Printing::Lists}.
* Added {CommandKit::Printing::Tables}.

#### CommandKit::Colors

* Support disabling ANSI color output if the `NO_COLOR` environment variable is
  set.

#### CommandKit::Options

* Correct the option usage for long option flags that have optional values
  (ex: `--longopt[=VALUE]`).

### 0.3.0 / 2021-12-26

* Added {CommandKit::FileUtils}.

#### CommandKit::FileUtils

* Added {CommandKit::FileUtils#erb #erb}.

#### CommandKit::Colors

* Added {CommandKit::Colors::ANSI::RESET_FG RESET_FG}.
* Added {CommandKit::Colors::ANSI.bright_black bright_black}.
* Added {CommandKit::Colors::ANSI.gray gray}.
* Added {CommandKit::Colors::ANSI.bright_red bright_red}.
* Added {CommandKit::Colors::ANSI.bright_green bright_green}.
* Added {CommandKit::Colors::ANSI.bright_yellow bright_yellow}.
* Added {CommandKit::Colors::ANSI.bright_blue bright_blue}.
* Added {CommandKit::Colors::ANSI.bright_magenta bright_magenta}.
* Added {CommandKit::Colors::ANSI.bright_cyan bright_cyan}.
* Added {CommandKit::Colors::ANSI.bright_white bright_white}.
* Added {CommandKit::Colors::ANSI.on_bright_black on_bright_black}.
* Added {CommandKit::Colors::ANSI.on_gray on_gray}.
* Added {CommandKit::Colors::ANSI.on_bright_red on_bright_red}.
* Added {CommandKit::Colors::ANSI.on_bright_green on_bright_green}.
* Added {CommandKit::Colors::ANSI.on_bright_yellow on_bright_yellow}.
* Added {CommandKit::Colors::ANSI.on_bright_blue on_bright_blue}.
* Added {CommandKit::Colors::ANSI.on_bright_magenta on_bright_magenta}.
* Added {CommandKit::Colors::ANSI.on_bright_cyan on_bright_cyan}.
* Added {CommandKit::Colors::ANSI.on_bright_white on_bright_white}.

#### ComandKit::Options

* Allow grouping options into categories:

      option :opt1, category: 'Foo Options',
                    desc: 'Option 1'

      option :opt2, category: 'Foo Options',
                    desc: 'Option 1'

* Allow options to have multi-line descriptions:

      option :opt1, short: '-o',
                    desc: [
                            'line1',
                            'line2',
                            '...'
                          ]

#### CommandKit::Arguments

* Allow arguments to have multi-line descriptions:

      argument :arg1, desc: [
                              'line1',
                              'line2',
                              '...'
                            ]


#### CommandKit::ProgramName

* Added {CommandKit::ProgramName#command_name}.

### 0.2.2 / 2021-12-26

#### CommandKit::Help::Man

* Raise a `NotImplementedError` exception in {CommandKit::Help::Man#help_man
  #help_man} if {CommandKit::Help::Man::ClassMethods#man_dir .man_dir} was not
  set.

### 0.2.1 / 2021-11-16

* Ensure that all error messages end with a period.
* Documentation fixes.
* Opt-in to [rubygem.org MFA requirement](https://guides.rubygems.org/mfa-requirement-opt-in/).

#### CommandKit::Printing

* Auto-detect whether {CommandKit::CommandName#command_name #command_name} is
  available, and if so, prepend the command name to all error messages.

#### CommandKit::Help::Man

* Expand the path given to
  {CommandKit::Help::Man::ClassMethods#man_dir man_dir}.
* If {CommandKit::Help::Man::ClassMethods#man_dir man_dir} is not set, fallback
  to regular `--help` output.

#### CommandKit::Arguments

* Include {CommandKit::Usage} and {CommandKit::Printing} into
  {CommandKit::Arguments}.

#### CommandKit::Options

* Include {CommandKit::Arguments} into {CommandKit::Options}.
* Ensure that {CommandKit::Options::Parser#main} runs before
  {CommandKit::Arguments#main}.
* Ensure that {CommandKit::Options#help} also calls
  {CommandKit::Arguments#help_arguments}.
* Always prepopulate {CommandKit::Options#options #options} with option's
  default values.
  * Note: if an option has a default value but the option's value is not
    required (ex: `value: {required: false, default: "foo"}`), and the option's
    flag is given but no value is given (ex: `--option-flag --some-other-flag`),
    the option's value in {CommandKit::Options#options #options} will be `nil`
    _not_ the option's default value (`"foo"`). This helps indicate that the
    option's flag was given but no value was given with it.

#### CommandKit::Options::OptionValue

* When a `Class` is passed to {CommandKit::Options::OptionValue.default_usage},
  demodularize the class name before converting it to underscored/uppercase.

#### CommandKit::Command

* Fixed the inclusion order of {CommandKit::Options} and
  {CommandKit::Arguments}.

#### CommandKit::Commands

* Define the `COMMAND` and `ARGS` arguments.
* Correctly duplicate the {CommandKit::Env#env env} (which can be either `ENV`
  or a `Hash`) to work on ruby-3.1.0-preview1.
* Print command aliases that were set explicitly
  (ex: `command_aliases['rm'] = 'remove'`) in {CommandKit::Commands#help}.
* Print help and exit with status `1` if no command is given. This matches the
  behavior of the `git` command.

#### CommandKit::Commands::AutoLoad

* Ensure that any explicit command aliases are added to the command's
  {CommandKit::Commands::ClassMethods#command_aliases command_aliases}.

### 0.2.0 / 2021-08-31

* Added {CommandKit::Colors::ANSI#on_black}.
* Added {CommandKit::Colors::ANSI#on_red}.
* Added {CommandKit::Colors::ANSI#on_green}.
* Added {CommandKit::Colors::ANSI#on_yellow}.
* Added {CommandKit::Colors::ANSI#on_blue}.
* Added {CommandKit::Colors::ANSI#on_magenta}.
* Added {CommandKit::Colors::ANSI#on_cyan}.
* Added {CommandKit::Colors::ANSI#on_white}.
* Added {CommandKit::Man}.
* Added {CommandKit::OS#bsd?}.
* Added {CommandKit::OS#freebsd?}.
* Added {CommandKit::OS#netbsd?}.
* Added {CommandKit::OS#openbsd?}.
* Added {CommandKit::OS#os}.
* Added {CommandKit::OS#unix?}.
* Added {CommandKit::OS::Linux}.
* Added {CommandKit::OpenApp}.
* Added {CommandKit::PackageManager}.
* Added {CommandKit::Pager#pipe_to_pager}.
* Added {CommandKit::Sudo}.
* Added {CommandKit::Terminal#tty?}.
* Refactor {CommandKit::Inflector.camelize} and
  {CommandKit::Inflector.underscore} to use StringScanner.
* Allow {CommandKit::OS#initialize} to accept an `os:` keyword to override the
  detected OS.

### 0.1.0 / 2021-07-16

* Initial release:
  * {CommandKit::Arguments}
  * {CommandKit::Colors}
  * {CommandKit::Command}
  * {CommandKit::CommandName}
  * {CommandKit::Commands}
    * {CommandKit::Commands::AutoLoad}
    * {CommandKit::Commands::AutoRequire}
  * {CommandKit::Description}
  * {CommandKit::Env}
    * {CommandKit::Env::Home}
    * {CommandKit::Env::Path}
  * {CommandKit::Examples}
  * {CommandKit::ExceptionHandler}
  * {CommandKit::Help}
    * {CommandKit::Help::Man}
  * {CommandKit::Interactive}
  * {CommandKit::Main}
  * {CommandKit::Options}
    * {CommandKit::Options::Quiet}
    * {CommandKit::Options::Verbose}
  * {CommandKit::OS}
  * {CommandKit::Pager}
  * {CommandKit::Printing}
    * {CommandKit::Printing::Indent}
  * {CommandKit::ProgramName}
  * {CommandKit::Stdio}
  * {CommandKit::Terminal}
  * {CommandKit::Usage}
  * {CommandKit::XDG}

