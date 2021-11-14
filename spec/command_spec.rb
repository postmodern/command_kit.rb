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

  it "must include FileUtils" do
    expect(described_class).to include(FileUtils)
  end

  module TestCommandClass
    class TestCommand < CommandKit::Command

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

    end
  end

  let(:command_class) { TestCommandClass::TestCommand }
  subject { command_class.new }

  describe "#help" do
    let(:option1)   { command_class.options[:count]   }
    let(:option2)   { command_class.options[:output]  }
    let(:option3)   { command_class.options[:verbose] }
    let(:argument1) { command_class.arguments[:file]  }

    it "must print the usage, options, arguments, examples, and description" do
      expect { subject.help }.to output(
        [
          "Usage: #{subject.usage}",
          '',
          'Options:',
          "    #{option1.usage.join(', ').ljust(33 - 1)} #{option1.desc}",
          "    #{option2.usage.join(', ').ljust(33 - 1)} #{option2.desc}",
          "    #{option3.usage.join(', ').ljust(33 - 1)} #{option3.desc}",
          '    -h, --help                       Print help information',
          '',
          "Arguments:",
          "    #{argument1.usage.ljust(33)}#{argument1.desc}",
          '',
          "Examples:",
          "    #{subject.command_name} #{command_class.examples[0]}",
          "    #{subject.command_name} #{command_class.examples[1]}",
          '',
          command_class.description
        ].join($/)
      ).to_stdout
    end
  end
end
