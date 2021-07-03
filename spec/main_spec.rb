require 'spec_helper'
require 'command_kit/main'

describe CommandKit::Main do
  module TestMain
    class TestCommand
      include CommandKit::Main
    end

    class TestCommandWithInitialize
      include CommandKit::Main

      attr_reader :foo

      attr_reader :bar

      def initialize(foo: 'foo', bar: 'bar', **kwargs)
        super(**kwargs)

        @foo = foo
        @bar = bar
      end
    end
  end

  let(:command_class) { TestMain::TestCommand }

  describe ".start" do
    subject { command_class }

    it "must exit with 0 by default" do
      expect(subject).to receive(:exit).with(0)

      subject.start
    end

    context "when given an argv argument" do
      let(:argv) { %w[one two three] }

      it "must pass argv to .main" do
        expect(subject).to receive(:main).with(argv)
        allow(subject).to receive(:exit)

        subject.start(argv)
      end
    end

    context "when given keyword arguments" do
      let(:command_class) { TestMain::TestCommandWithInitialize }

      let(:kwargs) { {foo: 'custom foo', bar: 'custom bar'} }

      it "must pass the keyword arguments down to .main" do
        expect(subject).to receive(:main).with(ARGV, **kwargs)
        allow(subject).to receive(:exit)

        subject.start(**kwargs)
      end
    end

    context "when Interrupt is raised" do
      module TestMain
        class TestCommandWithInterrupt
          include CommandKit::Main

          def main(*argv)
            raise(Interrupt)
          end
        end
      end

      let(:command_class) { TestMain::TestCommandWithInterrupt }

      it "must exit with 130" do
        expect(command_class).to receive(:exit).with(130)

        command_class.start
      end
    end

    context "when Errno::EPIPE is raised" do
      module TestMain
        class TestCommandWithBrokenPipe
          include CommandKit::Main

          def main(*argv)
            raise(Errno::EPIPE)
          end
        end
      end

      let(:command_class) { TestMain::TestCommandWithBrokenPipe }

      it "must exit with 0" do
        expect(command_class).to receive(:exit).with(0)

        command_class.start
      end
    end
  end

  module TestMain
    class TestCommandWithSystemExit

      include CommandKit::Main

      def run(*argv)
        raise(SystemExit.new(-1))
      end

    end
  end

  describe ".main" do
    subject { command_class }

    it "must return 0 by default" do
      expect(subject.main).to eq(0)
    end

    let(:command_class) { TestMain::TestCommandWithInitialize }

    context "when given a custom argv" do
      let(:instance) { command_class.new }
      let(:argv)     { %w[one two three] }

      it "must call #main with the custom argv" do
        expect(subject).to receive(:new).with(no_args).and_return(instance)
        expect(instance).to receive(:main).with(argv)

        subject.main(argv)
      end
    end

    context "when given keyword arguments" do
      let(:kwargs)   { {foo: 'custom foo', bar: 'custom bar'} }
      let(:instance) { command_class.new(**kwargs) }

      it "must pass the keyword arguments .new then call #main" do
        expect(subject).to receive(:new).with(**kwargs).and_return(instance)
        expect(instance).to receive(:main).with([])

        subject.main(**kwargs)
      end
    end

    context "when #main raises SystemExit" do
      let(:command_class) { TestMain::TestCommandWithSystemExit }

      it "must rescue SystemExit and return the exit status code" do
        expect(subject.main()).to eq(-1)
      end
    end
  end

  describe "#main" do
    subject { command_class.new }

    it "must return 0 by default" do
      expect(subject.main).to eq(0)
    end

    it "must call #run with the given argv" do
      argv = ["foo", "bar", "baz"]

      expect(subject).to receive(:run).with(*argv)
      
      subject.main(argv)
    end

    context "when #run raises SystemExit" do
      let(:command_class) { TestMain::TestCommandWithSystemExit }

      it "must rescue SystemExit and return the exit status code" do
        expect(subject.main()).to eq(-1)
      end
    end
  end
end
