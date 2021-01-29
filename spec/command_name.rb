require 'spec_helper'
require 'command_kit/command_name'

describe CommandName do
  class SimpleCmd
    include CommandKit::CommandName
  end

  let(:subject_class) { SimpleCmd }

  describe ".command_name" do
    subject { SimpleCmd }

    context "when no command_name has been set" do
      it "should underscore the class'es name" do
        expect(subject.command_name).to eq('simple_cmd')
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

        subject { ImplicitInheritedCmd }

        it "must return the subclass'es command_name, not the superclass'es" do
          expect(subject.command_name).to eq('implicit_inherited_cmd')
        end
      end

      context "when the subclass defines an explicit command_name" do
        class ImplicitBaseCmd
          include CommandKit::CommandName
        end

        class ExplicitInheritedCmd < ImplicitBaseCmd
          command_name :explicit
        end

        subject { ExplicitInheritedCmd }

        it "must return the subclass'es command_name, not the superclass'es" do
          expect(subject.command_name).to eq('explicit')
        end
      end
    end
  end
end
