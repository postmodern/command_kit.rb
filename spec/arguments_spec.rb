require 'spec_helper'
require 'command_kit/arguments'

describe CommandKit::Arguments do
  module TestArguments
    class ImplicitCmd
      include CommandKit::Arguments
    end
  end

  let(:command_class) { TestArguments::ImplicitCmd }

  describe ".included" do
    subject { command_class }

    it { expect(subject).to include(CommandKit::Main) }
    it { expect(subject).to include(CommandKit::Help) }
  end

  describe ".arguments" do
    subject { TestArguments::ImplicitCmd }

    context "when no arguments have been defined" do
      it "should default to {}" do
        expect(subject.arguments).to eq({})
      end
    end

    context "when a arguments is explicitly set" do
      module TestArguments
        class ExplicitCmd
          include CommandKit::Arguments
          argument :foo, desc: 'Foo option'
          argument :bar, desc: 'Bar option'
        end
      end

      subject { TestArguments::ExplicitCmd }

      it "must return the explicitly set arguments" do
        expect(subject.arguments.keys).to eq([:foo, :bar])
      end
    end

    context "when the command class inherites from another class" do
      context "but no arguments are defined" do
        module TestArguments
          class BaseCmd
            include CommandKit::Arguments
          end

          class InheritedCmd < BaseCmd
          end
        end

        subject { TestArguments::InheritedCmd }

        it "must search each class then return {}"do
          expect(subject.arguments).to eq({})
        end
      end

      module TestArguments
        class ExplicitBaseCmd
          include CommandKit::Arguments
          argument :foo, desc: 'Foo option'
          argument :bar, desc: 'Bar option'
        end
      end

      context "when the superclass defines arguments" do
        module TestArguments
          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestArguments::ExplicitBaseCmd }
        subject { TestArguments::ImplicitInheritedCmd }

        it "must inherit the superclass'es arguments" do
          expect(subject.arguments).to eq(super_subject.arguments)
        end

        it "must not change the superclass'es arguments" do
          expect(super_subject.arguments.keys).to eq([:foo, :bar])
        end
      end

      context "when the subclass defines arguments" do
        module TestArguments
          class ImplicitBaseCmd
            include CommandKit::Arguments
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            argument :baz, desc: 'Baz option'
            argument :qux, desc: 'Qux option'
          end
        end

        let(:super_subject) { TestArguments::ImplicitBaseCmd }
        subject { TestArguments::ExplicitInheritedCmd }

        it "must return the subclass'es arguments" do
          expect(subject.arguments.keys).to eq([:baz, :qux])
        end

        it "must not change the superclass'es arguments" do
          expect(super_subject.arguments).to eq({})
        end
      end

      context "when subclass overrides the superclass's argumentss" do
        module TestArguments
          class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
            argument :foo, desc: "Overriden foo option"
          end
        end

        let(:super_subject) { TestArguments::ExplicitBaseCmd }
        subject { TestArguments::ExplicitOverridingInheritedCmd }

        it "must combine the superclass'es arguments with the subclass'es" do
          expect(subject.arguments.keys).to eq([:foo, :bar])
          expect(subject.arguments[:foo].desc).to eq("Overriden foo option")
          expect(subject.arguments[:bar].desc).to eq("Bar option")
        end

        it "must not change the superclass'es arguments" do
          expect(super_subject.arguments.keys).to eq([:foo, :bar])
          expect(super_subject.arguments[:foo].desc).to eq("Foo option")
          expect(super_subject.arguments[:bar].desc).to eq("Bar option")
        end
      end
    end
  end

  subject { command_class.new }

  describe "#help_arguments" do
    context "when #arguments returns {}" do
      module TestArguments
        class NoArguments
          include CommandKit::Arguments
        end
      end

      let(:command_class) { TestArguments::NoArguments }
      subject { command_class.new }

      it "must print out the arguments" do
        expect { subject.help_arguments }.to_not output.to_stdout
      end
    end

    context "when #arguments returns an Array" do
      module TestArguments
        class MultipleArguments
          include CommandKit::Arguments

          argument :foo, desc: "Foo option"
          argument :bar, desc: "Bar option"
          argument :baz, desc: "Baz option"
        end
      end

      let(:command_class) { TestArguments::MultipleArguments }
      subject { command_class.new }

      let(:foo_argument) { command_class.arguments[:foo] }
      let(:bar_argument) { command_class.arguments[:bar] }
      let(:baz_argument) { command_class.arguments[:baz] }

      it "must print out the 'Arguments:' section header and the arguments" do
        expect { subject.help_arguments }.to output(
          [
            '',
            "Arguments:",
            "    #{foo_argument.usage.ljust(33)}#{foo_argument.desc}",
            "    #{bar_argument.usage.ljust(33)}#{bar_argument.desc}",
            "    #{baz_argument.usage.ljust(33)}#{baz_argument.desc}",
            ''
          ].join($/)
        ).to_stdout
      end
    end
  end

  describe "#help" do
    it "must call #help_arguments" do
      expect(subject).to receive(:help_arguments)

      subject.help
    end
  end
end
