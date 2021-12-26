require 'spec_helper'
require 'command_kit/command'

describe CommandKit::Command do
  it "must include CommandKit::Main" do
    expect(described_class).to include(CommandKit::Main)
  end

  it "must include CommandKit::Env" do
    expect(described_class).to include(CommandKit::Env)
  end

  it "must include CommandKit::Stdio" do
    expect(described_class).to include(CommandKit::Stdio)
  end

  it "must include CommandKit::Printing" do
    expect(described_class).to include(CommandKit::Printing)
  end

  it "must include CommandKit::Help" do
    expect(described_class).to include(CommandKit::Help)
  end

  it "must include CommandKit::Usage" do
    expect(described_class).to include(CommandKit::Usage)
  end

  it "must include CommandKit::Options" do
    expect(described_class).to include(CommandKit::Options)
  end

  it "must include CommandKit::Arguments" do
    expect(described_class).to include(CommandKit::Arguments)
  end

  it "must include CommandKit::Examples" do
    expect(described_class).to include(CommandKit::Examples)
  end

  it "must include CommandKit::Description" do
    expect(described_class).to include(CommandKit::Description)
  end

  it "must include CommandKit::ExceptionHandler" do
    expect(described_class).to include(CommandKit::ExceptionHandler)
  end

  it "must include CommandKit::FileUtils" do
    expect(described_class).to include(CommandKit::FileUtils)
  end

  module TestCommandClass
    class TestCommand < CommandKit::Command

      usage '[OPTIONS] ARG1 [ARG2]'

      option :option1, short: '-a',
                       value: {
                         type: Integer,
                         default: 1
                       },
                       desc: "Option 1"

      option :option2, short: '-b',
                       value: {
                         type: String,
                         usage: 'FILE'
                       },
                       desc: "Option 2"

      argument :argument1, required: true,
                           usage:    'ARG1',
                           desc:     "Argument 1"

      argument :argument2, required: false,
                           usage:    'ARG2',
                           desc:     "Argument 2"

      examples [
        '-a 42 foo/bar/baz',
        '-a 42 -b bar.txt baz qux'
      ]

      description 'Example command'

    end
  end

  let(:command_class) { TestCommandClass::TestCommand }
  subject { command_class.new }

  describe "#help" do
    let(:option1)   { command_class.options[:option1]     }
    let(:option2)   { command_class.options[:option2]     }
    let(:argument1) { command_class.arguments[:argument1] }
    let(:argument2) { command_class.arguments[:argument2] }

    it "must print the usage, options, arguments, examples, and description" do
      expect { subject.help }.to output(
        [
          "Usage: #{subject.usage}",
          '',
          'Options:',
          "    #{option1.usage.join(', ').ljust(33 - 1)} #{option1.desc}",
          "    #{option2.usage.join(', ').ljust(33 - 1)} #{option2.desc}",
          '    -h, --help                       Print help information',
          '',
          "Arguments:",
          "    #{argument1.usage.ljust(33)}#{argument1.desc}",
          "    #{argument2.usage.ljust(33)}#{argument2.desc}",
          '',
          "Examples:",
          "    #{subject.command_name} #{command_class.examples[0]}",
          "    #{subject.command_name} #{command_class.examples[1]}",
          '',
          command_class.description,
          ''
        ].join($/)
      ).to_stdout
    end
  end
end
