require 'spec_helper'
require 'command_kit/examples'

describe Examples do
  module TestExamples
    class ImplicitCmd
      include CommandKit::Examples
    end
  end

  let(:command_class) { TestExamples::ImplicitCmd }

  describe ".examples" do
    subject { TestExamples::ImplicitCmd }

    context "when no examples have been set" do
      it "should default to nil" do
        expect(subject.examples).to be_nil
      end
    end

    context "when a examples is explicitly set" do
      module TestExamples
        class ExplicitCmd
          include CommandKit::Examples
          examples [
            '--example 1',
            '--example 2'
          ]
        end
      end

      subject { TestExamples::ExplicitCmd }

      it "must return the explicitly set examples" do
        expect(subject.examples).to eq([
          '--example 1',
          '--example 2'
        ])
      end
    end

    context "when the command class inherites from another class" do
      context "but no examples is set" do
        module TestExamples
          class BaseCmd
            include CommandKit::Examples
          end

          class InheritedCmd < BaseCmd
          end
        end

        subject { TestExamples::InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.examples).to be_nil
        end
      end

      module TestExamples
        class ExplicitBaseCmd
          include CommandKit::Examples
          examples [
            '--example 1',
            '--example 2'
          ]
        end
      end

      context "when the superclass defines an explicit examples" do
        module TestExamples
          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestExamples::ExplicitBaseCmd }
        subject { TestExamples::ImplicitInheritedCmd }

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
        module TestExamples
          class ImplicitBaseCmd
            include CommandKit::Examples
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            examples [
              '--example 1',
              '--example 2'
            ]
          end
        end

        let(:super_subject) { TestExamples::ImplicitBaseCmd }
        subject { TestExamples::ExplicitInheritedCmd }

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
        module TestExamples
          class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
            examples [
              '--example override'
            ]
          end
        end

        let(:super_subject) { TestExamples::ExplicitBaseCmd }
        subject { TestExamples::ExplicitOverridingInheritedCmd }

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

  subject { command_class.new }

  describe "#examples" do
    it "must be the same as .examples" do
      expect(subject.examples).to eq(command_class.examples)
    end
  end

  describe "#help_examples" do
    context "when #examples returns nil" do
      module TestExamples
        class NoExamples
          include CommandKit::Examples
        end
      end

      let(:command_class) { TestExamples::NoExamples }
      subject { command_class.new }

      it "must print out the examples" do
        expect { subject.help_examples }.to_not output.to_stdout
      end
    end

    context "when #examples returns an Array" do
      module TestExamples
        class MultipleExamples
          include CommandKit::Examples

          examples [
            '--example 1',
            '--example 2',
            '--example 3'
          ]
        end
      end

      let(:command_class) { TestExamples::MultipleExamples }
      subject { command_class.new }

      it "must print out the 'Examples:' section header and the examples" do
        expect { subject.help_examples }.to output(
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

  describe "#help" do
    it "must call #help_examples" do
      expect(subject).to receive(:help_examples)

      subject.help
    end
  end
end
