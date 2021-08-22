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

