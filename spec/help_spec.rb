require 'spec_helper'
require 'command_kit/help'

describe CommandKit::Help do
  module TestHelp
    class DefaultCmd
      include CommandKit::Help
    end

    class TestCommandWithInitialize
      include CommandKit::Help

      attr_reader :foo

      attr_reader :bar

      def initialize(foo: 'foo', bar: 'bar', **kwargs)
        super(**kwargs)

        @foo = foo
        @bar = bar
      end
    end
  end

  let(:command_class) { TestHelp::TestCmd }

  describe ".help" do
    subject { command_class }

    context "when no #initialize method is defined" do
      let(:command_class) { TestHelp::DefaultCmd }
      let(:instance) { command_class.new }

      it "must initialize the command object and call #help" do
        expect(subject).to receive(:new).with(no_args).and_return(instance)
        expect(instance).to receive(:help).with(no_args)

        subject.help()
      end
    end

    context "when an #initialize method is defined" do
      let(:command_class) { TestHelp::TestCommandWithInitialize }
      let(:instance) { command_class.new }

      context "and given no arguments" do
        it "must initialize the command object and call #help" do
          expect(subject).to receive(:new).with(no_args).and_return(instance)
          expect(instance).to receive(:help).with(no_args)

          subject.help()
        end
      end

      context "and given keyword arguments" do
        let(:kwargs) { {foo: 'custom foo', bar: 'custom bar'} }
        let(:instance) { command_class.new(**kwargs) }

        it "must pass the keyword arguments .new then call #help" do
          expect(subject).to receive(:new).with(**kwargs).and_return(instance)
          expect(instance).to receive(:help).with(no_args)

          subject.help(**kwargs)
        end
      end
    end
  end

  subject { command_class.new }

  describe "#help" do
    context "when there is no superclass #help method" do
      module TestHelp
        class SuperclassWithoutHelp
        end

        class SubclassOfSuperclassWithoutHelp < SuperclassWithoutHelp
          include CommandKit::Help
        end
      end

      let(:command_superclass) { TestHelp::SuperclassWithoutHelp }
      let(:command_class)      { TestHelp::SubclassOfSuperclassWithoutHelp }

      it "must not attempt to call the superclass'es #help" do
        allow_any_instance_of(command_class).to receive(:help)
        expect_any_instance_of(command_superclass).to_not receive(:help)

        subject.help()
      end
    end

    context "when the superclass defines it's own #help method" do
      module TestHelp
        class SuperclassWithHelp

          def help
            puts 'superclass'
          end

        end

        class SubclassOfSuperclassWithHelp < SuperclassWithHelp
          include CommandKit::Help
        end
      end

      let(:command_superclass) { TestHelp::SuperclassWithHelp }
      let(:command_class)      { TestHelp::SubclassOfSuperclassWithHelp }

      it "must call the superclass'es #help" do
        expect_any_instance_of(command_superclass).to receive(:help)

        subject.help()
      end
    end
  end
end
