# frozen_string_literal: true

require_relative 'stdio'

module CommandKit
  #
  # Provides methods for asking the user for input.
  #
  # ## Examples
  #
  #     first_name = ask("First name")
  #     last_name = ask("Last name")
  #
  # ### Asking for secret input
  #
  #     password = ask_secret("Password")
  #
  # ### Asking Y/N?
  #
  #     if ask_yes_or_no("Proceed anyways?")
  #       # ...
  #     else
  #       stderr.puts "Aborting!"
  #     end
  #
  # ### Asking multi-choice questions
  #
  #     ask_multiple_choice("Select a flavor", %w[Apple Orange Lemon Lime])
  #     #   1) Apple
  #     #   2) Orange
  #     #   3) Lemon
  #     #   4) Lime
  #     #   Select a flavor: 4
  #     #
  #     # => "Lime"
  #
  module Interactive
    include Stdio

    #
    # Asks the user for input.
    #
    # @param [String] prompt
    #   The prompt that will be printed before reading input.
    #
    # @param [String, nil] default
    #   The default value to return if no input is given.
    #
    # @param [Boolean] required
    #   Requires non-empty input.
    #
    # @return [String]
    #   The user input.
    #
    # @example
    #   first_name = ask("First name")
    #   last_name = ask("Last name")
    #
    # @example Default value:
    #   ask("Country", default: "EU")
    #   # Country [EU]: <enter>
    #   # => "EU"
    #
    # @example Required non-empty input:
    #   ask("Email", required: true)
    #   # Email: <enter>
    #   # Email: bob@example.com<enter>
    #   # => "bob@example.com"
    #
    # @api public
    #
    def ask(prompt, default: nil, required: false)
      prompt = prompt.chomp
      prompt << " [#{default}]" if default
      prompt << ": "

      loop do
        stdout.print(prompt)

        value = stdin.gets(chomp: true)
        value ||= '' # convert nil values (ctrl^D) to an empty String

        if value.empty?
          if required
            next
          else
            return (default || value)
          end
        else
          return value
        end
      end
    end

    #
    # Asks the user a yes or no question.
    #
    # @param [String] prompt
    #   The prompt that will be printed before reading input.
    #
    # @param [true, false,  nil] default
    #
    # @return [Boolean]
    #   Specifies whether the user entered Y/yes.
    #
    # @example
    #   ask_yes_or_no("Proceed anyways?")
    #   # Proceed anyways? (Y/N): Y
    #   # => true
    #
    # @example Default value:
    #   ask_yes_or_no("Proceed anyways?", default: true)
    #   # Proceed anyways? (Y/N) [Y]: <enter>
    #   # => true
    #
    # @api public
    #
    def ask_yes_or_no(prompt, default: nil, **kwargs)
      default = case default
                when true  then 'Y'
                when false then 'N'
                when nil  then nil
                else
                  raise(ArgumentError,"invalid default: #{default.inspect}")
                end

      prompt = "#{prompt} (Y/N)"

      loop do
        answer = ask(prompt, **kwargs, default: default)

        case answer.downcase
        when 'y', 'yes'
          return true
        else
          return false
        end
      end
    end

    #
    # Asks the user to select a choice from a list of options.
    #
    # @param [String] prompt
    #   The prompt that will be printed before reading input.
    #
    # @param [Hash{String => String}, Array<String>] choices
    #   The choices to select from.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments for {#ask}.
    #
    # @option kwargs [String, nil] default
    #   The default option to fallback to, if no input is given.
    #
    # @option kwargs [Boolean] required
    #   Requires non-empty input.
    #
    # @return [String]
    #   The selected choice.
    #
    # @example Array of choices:
    #   ask_multiple_choice("Select a flavor", %w[Apple Orange Lemon Lime])
    #   #   1) Apple
    #   #   2) Orange
    #   #   3) Lemon
    #   #   4) Lime
    #   #   Select a flavor: 4
    #   #
    #   # => "Lime"
    #
    # @example Hash of choices:
    #   ask_multiple_choice("Select an option", {'A' => 'Foo',
    #                                            'B' => 'Bar',
    #                                            'X' => 'All of the above'})
    #   #   A) Foo
    #   #   B) Bar
    #   #   X) All of the above
    #   #   Select an option: X
    #   #
    #   # => "All of the above"
    #
    # @api public
    #
    def ask_multiple_choice(prompt,choices,**kwargs)
      choices = case choices
                when Array
                  Hash[choices.each_with_index.map { |value,i|
                    [(i+1).to_s, value]
                  }]
                when Hash
                  choices
                else
                  raise(TypeError,"unsupported choices class #{choices.class}: #{choices.inspect}")
                end

      prompt = "#{prompt} (#{choices.keys.join(', ')})"

      loop do
        # print the choices
        choices.each do |choice,value|
          stdout.puts "  #{choice}) #{value}"
        end
        stdout.puts

        # read the choice
        choice = ask(prompt,**kwargs)

        if choices.has_key?(choice)
          # if a valid choice is given, return the value
          return choices[choice]
        else
          stderr.puts "Invalid selection: #{choice}"
        end
      end
    end

    #
    # Asks the user for secret input.
    #
    # @param [String] prompt
    #   The prompt that will be printed before reading input.
    #
    # @param [Boolean] required
    #   Requires non-empty input.
    #
    # @return [String]
    #   The user input.
    #
    # @example
    #   ask_secret("Password")
    #   # Password: 
    #   # => "s3cr3t"
    #
    # @api public
    #
    def ask_secret(prompt, required: true)
      if stdin.respond_to?(:noecho)
        stdin.noecho do
          ask(prompt, required: required)
        end
      else
        ask(prompt, required: required)
      end
    end

  end
end
