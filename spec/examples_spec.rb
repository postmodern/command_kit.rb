require 'spec_helper'
require 'command_kit/examples'

describe Examples do
  class ImplicitCmd
    include CommandKit::Examples
  end

  let(:subject_class) { ImplicitCmd }

  describe ".examples" do
    subject { ImplicitCmd }

    context "when no examples have been set" do
      it "should default to nil" do
        expect(subject.examples).to be_nil
      end
    end

    context "when a examples is explicitly set" do
      class ExplicitCmd
        include CommandKit::Examples
        examples [
          '--example 1',
          '--example 2'
        ]
      end

      subject { ExplicitCmd }

      it "must return the explicitly set examples" do
        expect(subject.examples).to eq([
          '--example 1',
          '--example 2'
        ])
      end
    end

    context "when the command class inherites from another class" do
      context "but no examples is set" do
        class BaseCmd
          include CommandKit::Examples
        end

        class InheritedCmd < BaseCmd
        end

        subject { InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.examples).to be_nil
        end
      end

      class ExplicitBaseCmd
        include CommandKit::Examples
        examples [
          '--example 1',
          '--example 2'
        ]
      end

      context "when the superclass defines an explicit examples" do
        class ImplicitInheritedCmd < ExplicitBaseCmd
        end

        let(:super_subject) { ExplicitBaseCmd }
        subject { ImplicitInheritedCmd }

        it "must inherit the superclass'es examples" do
          expect(subject.examples).to eq(super_subject.examples)
        end

        it "must not change the superclass'es examples" do
          expect(super_subject.examples).to eq([
            '--example 1',
            '--example 2'
          ])
        end
      end

      context "when the subclass defines an explicit examples" do
        class ImplicitBaseCmd
          include CommandKit::Examples
        end

        class ExplicitInheritedCmd < ImplicitBaseCmd
          examples [
            '--example 1',
            '--example 2'
          ]
        end

        let(:super_subject) { ImplicitBaseCmd }
        subject { ExplicitInheritedCmd }

        it "must return the subclass'es examples" do
          expect(subject.examples).to eq([
            '--example 1',
            '--example 2'
          ])
        end

        it "must not change the superclass'es examples" do
          expect(super_subject.examples).to be_nil
        end
      end

      context "when both the subclass overrides the superclass's exampless" do
        class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
          examples [
            '--example override'
          ]
        end

        let(:super_subject) { ExplicitBaseCmd }
        subject { ExplicitOverridingInheritedCmd }

        it "must return the subclass'es examples" do
          expect(subject.examples).to eq([
            '--example override'
          ])
        end

        it "must not change the superclass'es examples" do
          expect(super_subject.examples).to eq([
            '--example 1',
            '--example 2'
          ])
        end
      end
    end
  end

  describe "#examples" do
    subject { subject_class.new }

    it "must be the same as .examples" do
      expect(subject.examples).to eq(subject_class.examples)
    end
  end

  describe "#help" do
    context "when #examples returns nil" do
      class NoExamples
        include CommandKit::Examples
      end

      let(:subject_class) { NoExamples }
      subject { subject_class.new }

      it "must print out the examples" do
        expect { subject.help }.to_not output.to_stdout
      end
    end

    context "when #examples returns an Array" do
      class MultipleExamples
        include CommandKit::Examples

        examples [
          '--example 1',
          '--example 2',
          '--example 3'
        ]
      end

      let(:subject_class) { MultipleExamples }
      subject { subject_class.new }

      it "must print out the 'Examples:' section header and the examples" do
        expect { subject.help }.to output(
          [
            '',
            "Examples:",
            "    #{subject.command_name} #{subject.examples[0]}",
            "    #{subject.command_name} #{subject.examples[1]}",
            "    #{subject.command_name} #{subject.examples[2]}",
            ''
          ].join($/)
        ).to_stdout
      end
    end
  end
end
