require 'spec_helper'
require 'command_kit/description'

describe Description do
  module TestDescription
    class ImplicitCmd
      include CommandKit::Description
    end
  end

  let(:command_class) { TestDescription::ImplicitCmd }

  describe ".description" do
    subject { TestDescription::ImplicitCmd }

    context "when no description have been set" do
      it "should default to nil" do
        expect(subject.description).to be_nil
      end
    end

    context "when a description is explicitly set" do
      module TestDescription
        class ExplicitCmd
          include CommandKit::Description
          description "Example command"
        end
      end

      subject { TestDescription::ExplicitCmd }

      it "must return the explicitly set description" do
        expect(subject.description).to eq("Example command")
      end
    end

    context "when the command class inherites from another class" do
      context "but no description is set" do
        module TestDescription
          class BaseCmd
            include CommandKit::Description
          end

          class InheritedCmd < BaseCmd
          end
        end

        subject { TestDescription::InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.description).to be_nil
        end
      end

      module TestDescription
        class ExplicitBaseCmd
          include CommandKit::Description
          description "Example base command"
        end
      end

      context "when the superclass defines an explicit description" do
        module TestDescription
          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestDescription::ExplicitBaseCmd }
        subject { TestDescription::ImplicitInheritedCmd }

        it "must inherit the superclass'es description" do
          expect(subject.description).to eq(super_subject.description)
        end

        it "must not change the superclass'es description" do
          expect(super_subject.description).to eq("Example base command")
        end
      end

      context "when the subclass defines an explicit description" do
        module TestDescription
          class ImplicitBaseCmd
            include CommandKit::Description
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            description "Example inherited command"
          end
        end

        let(:super_subject) { TestDescription::ImplicitBaseCmd }
        subject { TestDescription::ExplicitInheritedCmd }

        it "must return the subclass'es description" do
          expect(subject.description).to eq("Example inherited command")
        end

        it "must not change the superclass'es description" do
          expect(super_subject.description).to be_nil
        end
      end

      context "when both the subclass overrides the superclass's descriptions" do
        module TestDescription
          class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
            description "Example overrided description"
          end
        end

        let(:super_subject) { TestDescription::ExplicitBaseCmd }
        subject { TestDescription::ExplicitOverridingInheritedCmd }

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
    subject { command_class.new }

    it "must be the same as .description" do
      expect(subject.description).to eq(command_class.description)
    end
  end

  describe "#help" do
    context "when #description returns nil" do
      module TestDescription
        class NoDescription
          include CommandKit::Description
        end
      end

      let(:command_class) { TestDescription::NoDescription }
      subject { command_class.new }

      it "must print out the description" do
        expect { subject.help }.to_not output.to_stdout
      end
    end

    context "when #description returns a String" do
      module TestDescription
        class DefinesDescription
          include CommandKit::Description

          description "Example command"
        end
      end

      let(:command_class) { TestDescription::DefinesDescription }
      subject { command_class.new }

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
