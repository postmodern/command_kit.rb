require 'spec_helper'
require 'command_kit/usage'

describe Usage do
  class ImplicitCmd
    include CommandKit::Usage
  end

  let(:subject_class) { ImplicitCmd }

  describe ".usage" do
    subject { ImplicitCmd }

    context "when no usage has been set" do
      it "should default to nil" do
        expect(subject.usage).to be_nil
      end
    end

    context "when a usage is explicitly set" do
      class ExplicitCmd
        include CommandKit::Usage
        usage 'EXPLICIT'
      end

      subject { ExplicitCmd }

      it "must return the explicitly set usage" do
        expect(subject.usage).to eq("EXPLICIT")
      end
    end

    context "when the command class inherites from another class" do
      context "but no usage is set" do
        class BaseCmd
          include CommandKit::Usage
        end

        class InheritedCmd < BaseCmd
        end

        subject { InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.usage).to be_nil
        end
      end

      class ExplicitBaseCmd
        include CommandKit::Usage
        usage 'EXPLICIT'
      end

      context "when the superclass defines an explicit usage" do
        class ImplicitInheritedCmd < ExplicitBaseCmd
        end

        let(:super_subject) { ExplicitBaseCmd }
        subject { ImplicitInheritedCmd }

        it "must inherit the superclass'es usage" do
          expect(subject.usage).to eq(super_subject.usage)
        end

        it "must not change the superclass'es usage" do
          expect(super_subject.usage).to eq("EXPLICIT")
        end
      end

      context "when the subclass defines an explicit usage" do
        class ImplicitBaseCmd
          include CommandKit::Usage
        end

        class ExplicitInheritedCmd < ImplicitBaseCmd
          usage 'EXPLICIT'
        end

        let(:super_subject) { ImplicitBaseCmd }
        subject { ExplicitInheritedCmd }

        it "must return the subclass'es usage" do
          expect(subject.usage).to eq("EXPLICIT")
        end

        it "must not change the superclass'es usage" do
          expect(super_subject.usage).to be_nil
        end
      end

      context "when both the subclass overrides the superclass's usages" do
        class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
          usage 'EXPLICIT_OVERRIDE'
        end

        let(:super_subject) { ExplicitBaseCmd }
        subject { ExplicitOverridingInheritedCmd }

        it "must return the subclass'es usage" do
          expect(subject.usage).to eq("EXPLICIT_OVERRIDE")
        end

        it "must not change the superclass'es usage" do
          expect(super_subject.usage).to eq("EXPLICIT")
        end
      end
    end
  end

  describe "#usage" do
    subject { subject_class.new }

    it "must be the same as .usage" do
      expect(subject.usage).to eq(subject_class.usage)
    end
  end

  describe "#help" do
    context "when #usage is nil" do
      class NoUsage
        include CommandKit::Usage
      end

      let(:subject_class) { NoUsage }
      subject { subject_class.new }

      it "must not print anything" do
        expect { subject.help }.to_not output.to_stdout
      end
    end

    context "when #usage is a String" do
      class SingleUsage
        include CommandKit::Usage

        usage 'ONE USAGE'
      end

      let(:subject_class) { SingleUsage }
      subject { subject_class.new }

      it "must print out only one usage" do
        expect { subject.help }.to output(
          "usage: #{subject.command_name} #{subject.usage}#{$/}"
        ).to_stdout
      end
    end

    context "when #usage is an Array of Strings" do
      class MultipleUsage
        include CommandKit::Usage

        usage [
          'ONE USAGE',
          'TWO USAGE',
          'THREE USAGE'
        ]
      end

      let(:subject_class) { MultipleUsage }
      subject { subject_class.new }

      it "must print out all usage Strings" do
        expect { subject.help }.to output(
          [
            "usage: #{subject.command_name} #{subject.usage[0]}",
            "       #{subject.command_name} #{subject.usage[1]}",
            "       #{subject.command_name} #{subject.usage[2]}",
            ''
          ].join($/)
        ).to_stdout
      end
    end
  end
end
