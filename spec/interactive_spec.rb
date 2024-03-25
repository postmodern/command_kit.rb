require 'spec_helper'
require 'command_kit/interactive'

describe CommandKit::Interactive do
  module TestInteractive
    class TestCommand
      include CommandKit::Interactive
    end
  end

  let(:command_class) { TestInteractive::TestCommand }

  describe "#included" do
    subject { command_class }

    it { expect(subject).to include(CommandKit::Stdio) }
  end

  let(:stdout) { StringIO.new }
  let(:stdin)  { StringIO.new }
  let(:stderr) { StringIO.new }

  subject do
    command_class.new(stdout: stdout, stdin: stdin, stderr: stderr)
  end

  let(:prompt) { 'Prompt' }

  describe "#ask" do
    let(:input)  { 'foo' }

    it "must print a prompt, read input, and return the input" do
      expect(stdout).to receive(:print).with("#{prompt}: ")
      expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

      expect(subject.ask(prompt)).to eq(input)
    end

    it "must accept empty user input by default" do
      expect(stdout).to receive(:print).with("#{prompt}: ")
      expect(stdin).to receive(:gets).with(chomp: true).and_return("")

      expect(subject.ask(prompt)).to eq("")
    end

    context "when Ctrl^C is entered" do
      it "must return \"\"" do
        # simulate Ctrl^C
        expect(stdin).to receive(:gets).with(chomp: true).and_return(nil)

        expect(subject.ask(prompt)).to eq("")
      end
    end

    context "when default: is given" do
      let(:default) { 'bar' }

      it "must include the default: value in the prompt" do
        expect(stdout).to receive(:print).with("#{prompt} [#{default}]: ")
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask(prompt, default: default)).to eq(input)
      end

      context "and non-empty user input is given" do
        it "must return the non-empty user input" do
          expect(stdout).to receive(:print).with("#{prompt} [#{default}]: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

          expect(subject.ask(prompt, default: default)).to eq(input)
        end
      end

      context "and empty user input is given" do
        it "must return the default value" do
          expect(stdout).to receive(:print).with("#{prompt} [#{default}]: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return("")

          expect(subject.ask(prompt, default: default)).to eq(default)
        end
      end
    end

    context "when required: is given" do
      context "and empty user input is given" do
        it "must ask for input again, until non-empty input is given" do
          expect(stdout).to receive(:print).with("#{prompt}: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return("")
          expect(stdout).to receive(:print).with("#{prompt}: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return("")
          expect(stdout).to receive(:print).with("#{prompt}: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

          expect(subject.ask(prompt, required: true)).to eq(input)
        end
      end

      context "and non-empty user input is given" do
        it "must return the non-empty user input" do
          expect(stdout).to receive(:print).with("#{prompt}: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

          expect(subject.ask(prompt, required: true)).to eq(input)
        end
      end
    end
  end

  describe "#ask_yes_or_no" do
    let(:input) { 'Y' }

    it "must print a prompt indicating Y/N, and then accept input" do
      expect(stdout).to receive(:print).with("#{prompt} (Y/N): ")
      expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

      subject.ask_yes_or_no(prompt)
    end

    context "when 'Y' is entered" do
      let(:input) { 'Y' }

      it "must return true" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(true)
      end
    end

    context "when 'y' is entered" do
      let(:input) { 'y' }

      it "must return true" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(true)
      end
    end

    context "when 'YES' is entered" do
      let(:input) { 'YES' }

      it "must return true" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(true)
      end
    end

    context "when 'Yes' is entered" do
      let(:input) { 'Yes' }

      it "must return true" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(true)
      end
    end

    context "when 'yes' is entered" do
      let(:input) { 'yes' }

      it "must return true" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(true)
      end
    end

    context "when 'N' is entered" do
      let(:input) { 'N' }

      it "must return false" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(false)
      end
    end

    context "when 'n' is entered" do
      let(:input) { 'n' }

      it "must return false" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(false)
      end
    end

    context "when 'NO' is entered" do
      let(:input) { 'NO' }

      it "must return false" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(false)
      end
    end

    context "when 'No' is entered" do
      let(:input) { 'No' }

      it "must return false" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(false)
      end
    end

    context "when 'no' is entered" do
      let(:input) { 'no' }

      it "must return false" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(false)
      end
    end

    context "when input besides y/n/yes/no is entered" do
      let(:input) { 'jflksjfls' }

      it "must return false" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_yes_or_no(prompt)).to eq(false)
      end
    end

    context "when defualt: is given" do
      context "and is true" do
        let(:default) { true }

        it "must include [Y] in the prompt" do
          expect(stdout).to receive(:print).with("#{prompt} (Y/N) [Y]: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

          subject.ask_yes_or_no(prompt, default: default)
        end

        context "and empty user-input is given" do
          let(:input) { "" }

          it "must return true" do
            expect(stdout).to receive(:print).with("#{prompt} (Y/N) [Y]: ")
            expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

            expect(subject.ask_yes_or_no(prompt, default: default)).to eq(default)
          end
        end
      end

      context "and is false" do
        let(:default) { false }

        it "must include [N] in the prompt" do
          expect(stdout).to receive(:print).with("#{prompt} (Y/N) [N]: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

          subject.ask_yes_or_no(prompt, default: default)
        end

        context "and empty user-input is given" do
          let(:input) { "" }

          it "must return false" do
            expect(stdout).to receive(:print).with("#{prompt} (Y/N) [N]: ")
            expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

            expect(subject.ask_yes_or_no(prompt, default: default)).to eq(default)
          end
        end
      end
    end
  end

  describe "#ask_multiple_choice" do
    context "when given an Array" do
      let(:choices) do
        [
          "foo",
          "bar",
          "baz"
        ]
      end

      let(:input) { "2" }

      it "must print the numbered choices, a prompt with the choices, read input, and return the choice" do
        expect(stdout).to receive(:puts).with("  1) #{choices[0]}")
        expect(stdout).to receive(:puts).with("  2) #{choices[1]}")
        expect(stdout).to receive(:puts).with("  3) #{choices[2]}")
        expect(stdout).to receive(:puts).with(no_args)
        expect(stdout).to receive(:print).with("#{prompt} (1, 2, 3): ")
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_multiple_choice(prompt,choices)).to eq(choices[input.to_i - 1])
      end

      context "when empty user-input is given" do
        it "must ask for input again, until non-empty input is given" do
          expect(stdin).to receive(:gets).with(chomp: true).and_return("")
          expect(stdin).to receive(:gets).with(chomp: true).and_return("")
          expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

          expect(subject.ask_multiple_choice(prompt,choices)).to eq(choices[input.to_i - 1])
        end
      end

      context "and default: is given" do
        let(:default) { '3' }

        it "must include the default: choice in the prompt" do
          expect(stdout).to receive(:print).with("#{prompt} (1, 2, 3) [#{default}]: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

          subject.ask_multiple_choice(prompt,choices, default: default)
        end

        context "and empty user-input is given" do
          it "must return the value for the default choice" do
            expect(stdin).to receive(:gets).with(chomp: true).and_return("")

            expect(subject.ask_multiple_choice(prompt,choices, default: default)).to eq(choices[default.to_i - 1])
          end
        end
      end
    end

    context "when given a Hash" do
      let(:choices) do
        {
          "A" => "foo",
          "B" => "bar",
          "C" => "baz"
        }
      end

      let(:input) { "B" }

      it "must print the labeled choices, a prompt with the choices, read input, and return the choice" do
        expect(stdout).to receive(:puts).with("  #{choices.keys[0]}) #{choices.values[0]}")
        expect(stdout).to receive(:puts).with("  #{choices.keys[1]}) #{choices.values[1]}")
        expect(stdout).to receive(:puts).with("  #{choices.keys[2]}) #{choices.values[2]}")
        expect(stdout).to receive(:puts).with(no_args)
        expect(stdout).to receive(:print).with("#{prompt} (#{choices.keys[0]}, #{choices.keys[1]}, #{choices.keys[2]}): ")
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_multiple_choice(prompt,choices)).to eq(choices[input])
      end

      context "when empty user-input is given" do
        it "must ask for input again, until non-empty input is given" do
          expect(stdin).to receive(:gets).with(chomp: true).and_return("")
          expect(stdin).to receive(:gets).with(chomp: true).and_return("")
          expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

          expect(subject.ask_multiple_choice(prompt,choices)).to eq(choices[input])
        end
      end

      context "and default: is given" do
        let(:default) { 'C' }

        it "must include the default: choice in the prompt" do
          expect(stdout).to receive(:print).with("#{prompt} (#{choices.keys[0]}, #{choices.keys[1]}, #{choices.keys[2]}) [#{default}]: ")
          expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

          subject.ask_multiple_choice(prompt,choices, default: default)
        end

        context "and empty user-input is given" do
          it "must return the value for the default choice" do
            expect(stdin).to receive(:gets).with(chomp: true).and_return("")

            expect(subject.ask_multiple_choice(prompt,choices, default: default)).to eq(choices[default])
          end
        end
      end
    end
  end

  describe "#ask_secret" do
    let(:input) { 's3cr3t' }

    context "when stdin supports to #noecho" do
      it "must call #noecho, read input, then return the input" do
        allow(stdin).to receive(:noecho).and_yield
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_secret(prompt)).to eq(input)
      end
    end

    context "when stdin does not support #noecho" do
      it "must fallback to reading input" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_secret(prompt)).to eq(input)
      end
    end

    context "when empty user-input is given" do
      it "must ask for input again, until non-empty input is given" do
        expect(stdin).to receive(:gets).with(chomp: true).and_return("")
        expect(stdin).to receive(:gets).with(chomp: true).and_return("")
        expect(stdin).to receive(:gets).with(chomp: true).and_return("")
        expect(stdin).to receive(:gets).with(chomp: true).and_return(input)

        expect(subject.ask_secret(prompt)).to eq(input)
      end
    end

    context "when required: is false" do
      context "and empty user-input is given" do
        it "must return the empty user-input" do
          expect(stdin).to receive(:gets).with(chomp: true).and_return("")

          expect(subject.ask_secret(prompt, required: false)).to eq("")
        end
      end
    end
  end

  describe "#ask_multiline" do
    let(:line1)      { 'foo bar' }
    let(:line2)      { 'baz qux' }
    let(:input)      { [line1, line2].join($/) }
    let(:terminator) { nil }

    it "must print a prompt, read multiple lines, and return the input on Ctrl^D" do
      expect(stdout).to receive(:puts).with("#{prompt} (Press Ctrl^D to exit): ")
      expect(stdin).to receive(:gets).with(terminator).and_return(input)

      expect(subject.ask_multiline(prompt)).to eq(input)
    end

    it "must accept empty user input by default" do
      expect(stdout).to receive(:puts).with("#{prompt} (Press Ctrl^D to exit): ")
      expect(stdin).to receive(:gets).with(terminator).and_return(nil)

      expect(subject.ask_multiline(prompt)).to eq("")
    end

    context "when Ctrl^C is entered" do
      it "must return \"\"" do
        # simulate Ctrl^C
        expect(stdin).to receive(:gets).with(terminator).and_return(nil)

        expect(subject.ask_multiline(prompt)).to eq("")
      end
    end

    context "when terminator: is given" do
      context "and it's :double_newline" do
        let(:terminator) { $/ * 2 }

        it "must change the help message in the prompt" do
          expect(stdout).to receive(:puts).with("#{prompt} (Press Enter twice to exit): ")
          expect(stdin).to receive(:gets).with(terminator).and_return("#{input}#{terminator}")

          subject.ask_multiline(prompt, terminator: :double_newline)
        end

        it "must return the entered input ending with the double newline terminator" do
          expect(stdout).to receive(:puts).with("#{prompt} (Press Enter twice to exit): ")
          expect(stdin).to receive(:gets).with(terminator).and_return("#{input}#{terminator}")

          expect(subject.ask_multiline(prompt, terminator: :double_newline)).to eq("#{input}#{terminator}")
        end
      end
    end

    context "when help: is given" do
      let(:help) { 'hit Enter twice to exit' }

      it "must override the default help message in the prompt" do
        expect(stdout).to receive(:puts).with("#{prompt} (#{help}): ")
        expect(stdin).to receive(:gets).with(terminator).and_return(input)

        expect(subject.ask_multiline(prompt, help: help)).to eq(input)
      end
    end

    context "when default: is given" do
      let(:default) { 'bar' }

      it "must include the default: value in the prompt" do
        expect(stdout).to receive(:puts).with("#{prompt} (Press Ctrl^D to exit) [#{default}]: ")
        expect(stdin).to receive(:gets).with(terminator).and_return(input)

        expect(subject.ask_multiline(prompt, default: default)).to eq(input)
      end

      context "and non-empty user input is given" do
        it "must return the non-empty user input" do
          expect(stdout).to receive(:puts).with("#{prompt} (Press Ctrl^D to exit) [#{default}]: ")
          expect(stdin).to receive(:gets).with(terminator).and_return(input)

          expect(subject.ask_multiline(prompt, default: default)).to eq(input)
        end
      end

      context "and empty user input is given" do
        it "must return the default value" do
          expect(stdout).to receive(:puts).with("#{prompt} (Press Ctrl^D to exit) [#{default}]: ")
          expect(stdin).to receive(:gets).with(terminator).and_return("")

          expect(subject.ask_multiline(prompt, default: default)).to eq(default)
        end
      end
    end

    context "when required: is given" do
      context "and empty user input is given" do
        it "must ask for input again, until non-empty input is given" do
          expect(stdout).to receive(:puts).with("#{prompt} (Press Ctrl^D to exit): ")
          expect(stdin).to receive(:gets).with(terminator).and_return("")
          expect(stdout).to receive(:puts).with("#{prompt} (Press Ctrl^D to exit): ")
          expect(stdin).to receive(:gets).with(terminator).and_return("")
          expect(stdout).to receive(:puts).with("#{prompt} (Press Ctrl^D to exit): ")
          expect(stdin).to receive(:gets).with(terminator).and_return(input)

          expect(subject.ask_multiline(prompt, required: true)).to eq(input)
        end
      end

      context "and non-empty user input is given" do
        it "must return the non-empty user input" do
          expect(stdout).to receive(:puts).with("#{prompt} (Press Ctrl^D to exit): ")
          expect(stdin).to receive(:gets).with(terminator).and_return(input)

          expect(subject.ask_multiline(prompt, required: true)).to eq(input)
        end
      end
    end
  end
end
