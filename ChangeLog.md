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

