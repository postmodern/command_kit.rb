require 'spec_helper'
require 'command_kit/command_name'

describe CommandName do
  class ImplicitCmd
    include CommandKit::CommandName
  end

  let(:subject_class) { ImplicitCmd }

  describe ".command_name" do
    subject { ImplicitCmd }

    context "when no command_name has been set" do
      it "should underscore the class'es name" do
        expect(subject.command_name).to eq('implicit_cmd')
      end
    end

    context "when a command_name is explicitly set" do
      class ExplicitCmd
        include CommandKit::CommandName
        command_name 'explicit'
      end

      subject { ExplicitCmd }

      it "must return the explicitly set command_name" do
        expect(subject.command_name).to eq('explicit')
      end
    end

    context "when the command class inherites from another class" do
      class BaseCmd
        include CommandKit::CommandName
      end

      class InheritedCmd < BaseCmd
      end

      subject { InheritedCmd }

      it "should underscore the class'es name" do
        expect(subject.command_name).to eq('inherited_cmd')
      end

      context "when the superclass defines an explicit command_name" do
        class ExplicitBaseCmd
          include CommandKit::CommandName
          command_name :explicit
        end

        class ImplicitInheritedCmd < ExplicitBaseCmd
        end

        let(:super_subject) { ExplicitBaseCmd }
        subject { ImplicitInheritedCmd }

        it "must return the subclass'es command_name, not the superclass'es" do
          expect(subject.command_name).to eq('implicit_inherited_cmd')
        end

        it "must not change the superclass'es command_name" do
          expect(super_subject.command_name).to eq('explicit')
        end
      end

      context "when the subclass defines an explicit command_name" do
        class ImplicitBaseCmd
          include CommandKit::CommandName
        end

        class ExplicitInheritedCmd < ImplicitBaseCmd
          command_name :explicit
        end

        let(:super_subject) { ImplicitBaseCmd }
        subject { ExplicitInheritedCmd }

        it "must return the subclass'es command_name, not the superclass'es" do
          expect(subject.command_name).to eq('explicit')
        end

        it "must not change the superclass'es command_name" do
          expect(super_subject.command_name).to eq('implicit_base_cmd')
        end
      end
    end
  end

  describe "#command_name" do
    let(:subject_class) { ImplicitCmd }

    subject { subject_class.new }

    it "must be the same as .command_name" do
      expect(subject.command_name).to eq(subject_class.command_name)
    end
  end
end
