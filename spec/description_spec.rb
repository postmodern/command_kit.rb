require 'spec_helper'
require 'command_kit/description'

describe Description do
  class ImplicitCmd
    include CommandKit::Description
  end

  let(:subject_class) { ImplicitCmd }

  describe ".description" do
    subject { ImplicitCmd }

    context "when no description have been set" do
      it "should default to nil" do
        expect(subject.description).to be_nil
      end
    end

    context "when a description is explicitly set" do
      class ExplicitCmd
        include CommandKit::Description
        description "Example command"
      end

      subject { ExplicitCmd }

      it "must return the explicitly set description" do
        expect(subject.description).to eq("Example command")
      end
    end

    context "when the command class inherites from another class" do
      context "but no description is set" do
        class BaseCmd
          include CommandKit::Description
        end

        class InheritedCmd < BaseCmd
        end

        subject { InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.description).to be_nil
        end
      end

      class ExplicitBaseCmd
        include CommandKit::Description
        description "Example base command"
      end

      context "when the superclass defines an explicit description" do
        class ImplicitInheritedCmd < ExplicitBaseCmd
        end

        let(:super_subject) { ExplicitBaseCmd }
        subject { ImplicitInheritedCmd }

        it "must inherit the superclass'es description" do
          expect(subject.description).to eq(super_subject.description)
        end

        it "must not change the superclass'es description" do
          expect(super_subject.description).to eq("Example base command")
        end
      end

      context "when the subclass defines an explicit description" do
        class ImplicitBaseCmd
          include CommandKit::Description
        end

        class ExplicitInheritedCmd < ImplicitBaseCmd
          description "Example inherited command"
        end

        let(:super_subject) { ImplicitBaseCmd }
        subject { ExplicitInheritedCmd }

        it "must return the subclass'es description" do
          expect(subject.description).to eq("Example inherited command")
        end

        it "must not change the superclass'es description" do
          expect(super_subject.description).to be_nil
        end
      end

      context "when both the subclass overrides the superclass's descriptions" do
        class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
          description "Example overrided description"
        end

        let(:super_subject) { ExplicitBaseCmd }
        subject { ExplicitOverridingInheritedCmd }

        it "must return the subclass'es description" do
          expect(subject.description).to eq("Example overrided description")
        end

        it "must not change the superclass'es description" do
          expect(super_subject.description).to eq("Example base command")
        end
      end
    end
  end

  describe "#description" do
    subject { subject_class.new }

    it "must be the same as .description" do
      expect(subject.description).to eq(subject_class.description)
    end
  end

  describe "#help" do
    context "when #description returns nil" do
      class NoDescription
        include CommandKit::Description
      end

      let(:subject_class) { NoDescription }
      subject { subject_class.new }

      it "must print out the description" do
        expect { subject.help }.to_not output.to_stdout
      end
    end

    context "when #description returns a String" do
      class DefinesDescription
        include CommandKit::Description

        description "Example command"
      end

      let(:subject_class) { DefinesDescription }
      subject { subject_class.new }

      it "must print out the description" do
        expect { subject.help }.to output(
          [
            '',
            subject.description,
            ''
          ].join($/)
        ).to_stdout
      end
    end
  end
end
