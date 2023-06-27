require 'spec_helper'
require 'command_kit/options/parser'

describe CommandKit::Options::Parser do
  module TestOptionsParser
    class TestCommand
      include CommandKit::Options::Parser

      command_name 'cmd'

    end
  end

  let(:command_class) { TestOptionsParser::TestCommand }

  describe ".included" do
    subject { command_class }

    it { expect(subject).to include(CommandKit::Main) }
    it { expect(subject).to include(CommandKit::Usage) }
    it { expect(subject.usage).to eq('[options]') }

    context "when the command class already defines a usage string" do
      module TestOptionParser
        class TestCommandWithUsage
          include CommandKit::Usage

          usage '[options] ARGS...'

          include CommandKit::Options::Parser
        end
      end

      let(:command_class) { TestOptionParser::TestCommandWithUsage }
      subject { command_class }

      it "must not override the usage" do
        expect(subject.usage).to eq('[options] ARGS...')
      end
    end
  end

  subject { command_class.new }

  describe "#initialize" do
    it "must initialize #option_parser" do
      expect(subject.option_parser).to be_kind_of(OptionParser)
    end
  end

  describe "#option_parser" do
    it "must have a default #banner" do
      expect(subject.option_parser.banner).to eq("Usage: #{subject.usage}")
    end

    it "must define a default --help option" do
      expect(subject.option_parser.to_s).to include(
        [
          '',
          '    -h, --help                       Print help information',
          ''
        ].join($/)
      )
    end
  end

  module TestOptionsParser
    class CommandWithOptions

      include CommandKit::Options::Parser

      command_name 'cmd'

      attr_reader :foo

      attr_reader :bar

      attr_reader :argv

      def initialize(**kwargs)
        super(**kwargs)

        @option_parser.on('-f','--foo','Foo option') do
          @foo = true
        end

        @option_parser.on('-b','--bar BAR',Integer,'Bar option') do |bar|
          @bar = bar
        end
      end

      def run(*argv)
        @argv = argv
      end

    end
  end

  let(:command_class) { TestOptionsParser::CommandWithOptions }
  subject { command_class.new }

  describe "#option_parser" do
    it { expect(subject.option_parser).to be_kind_of(OptionParser) }
  end

  describe "#main" do
    context "when --help is given as an argument" do
      it "must call #help" do
        expect(subject).to receive(:help)

        subject.main(['--help'])
      end

      it "must return 0" do
        allow(subject).to receive(:help)

        expect(subject.main(['--help'])).to eq(0)
      end

      it "must stop parsing options" do
        allow(subject).to receive(:help)
        subject.main(['--help', '--foo', '1'])

        expect(subject.foo).to be(nil)
        expect(subject.argv).to be(nil)
      end
    end
  end

  describe "#parse_options" do
    it "must parse options and return any additional arguments" do
      additional_args = %w[arg1 arg2]
      bar = 2
      argv = ['--foo', '--bar', bar.to_s, *additional_args]

      expect(subject.parse_options(argv)).to eq(additional_args)
      expect(subject.foo).to eq(true)
      expect(subject.bar).to eq(bar)
    end

    context "when -h,--help is passed" do
      it "must call #help and exit with 0" do
        expect(subject).to receive(:help)
        expect(subject).to receive(:exit).with(0)

        subject.parse_options(['--help'])
      end
    end

    context "when an invalid option is given" do
      it "must call #on_invalid_option" do
        expect(subject).to receive(:on_invalid_option).with(OptionParser::InvalidOption)

        subject.parse_options(['--xxx'])
      end
    end

    context "when an invalid argument is given" do
      it "must call #on_invalid_argument" do
        expect(subject).to receive(:on_invalid_argument).with(OptionParser::InvalidArgument)

        subject.parse_options(['--bar', 'xxx'])
      end
    end

    context "when a required argument is missing" do
      it "must call #on_missing_argument" do
        expect(subject).to receive(:on_missing_argument).with(OptionParser::MissingArgument)

        subject.parse_options(['--bar'])
      end
    end

    context "when a needless argument is given" do
      it "must call #on_needless_argument" do
        expect(subject).to receive(:on_needless_argument).with(OptionParser::NeedlessArgument)

        subject.parse_options(['--foo=xxx'])
      end
    end
  end

  describe "#on_parse_error" do
    let(:error) { OptionParser::InvalidOption.new("--xxx") }

    it "must print an error message and exit with 1" do
      expect(subject).to receive(:exit).with(1)

      expect { subject.on_parse_error(error) }.to output(
        [
          "#{subject.command_name}: #{error.message}",
          "Try '#{subject.command_name} --help' for more information.",
          ''
        ].join($/)
      ).to_stderr
    end
  end

  describe "#on_invalid_option" do
    let(:error) { OptionParser::InvalidOption.new('--xxx') }

    it "must call #on_parse_error by default" do
      expect(subject).to receive(:on_parse_error).with(error)

      subject.on_invalid_option(error)
    end
  end

  describe "#on_ambiguous_option" do
    let(:error) { OptionParser::AmbiguousOption.new('--xxx') }

    it "must call #on_parse_error by default" do
      expect(subject).to receive(:on_parse_error).with(error)

      subject.on_ambiguous_option(error)
    end
  end

  describe "#on_invalid_argument" do
    let(:error) { OptionParser::InvalidArgument.new('--xxx') }

    it "must call #on_parse_error by default" do
      expect(subject).to receive(:on_parse_error).with(error)

      subject.on_invalid_argument(error)
    end
  end

  describe "#on_missing_argument" do
    let(:error) { OptionParser::MissingArgument.new('--xxx') }

    it "must call #on_parse_error by default" do
      expect(subject).to receive(:on_parse_error).with(error)

      subject.on_missing_argument(error)
    end
  end

  describe "#on_needless_argument" do
    let(:error) { OptionParser::NeedlessArgument.new('--xxx') }

    it "must call #on_parse_error by default" do
      expect(subject).to receive(:on_parse_error).with(error)

      subject.on_needless_argument(error)
    end
  end

  describe "#on_ambiguous_argument" do
    let(:error) { OptionParser::AmbiguousArgument.new('--xxx') }

    it "must call #on_parse_error by default" do
      expect(subject).to receive(:on_parse_error).with(error)

      subject.on_ambiguous_argument(error)
    end
  end

  describe "#help_options" do
    it "must print the #option_parser" do
      expect { subject.help_options }.to output(
        subject.option_parser.to_s
      ).to_stdout
    end
  end

  describe "#help" do
    it "must call #help_options" do
      expect(subject).to receive(:help_options)

      subject.help
    end
  end
end
