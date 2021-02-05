require 'spec_helper'
require 'command_kit/command_name'

describe CommandName do
  module TestCommandName
    class ImplicitCmd
      include CommandKit::CommandName
    end
  end

  let(:command_class) { TestCommandName::ImplicitCmd }

  describe ".command_name" do
    subject { command_class }

    context "when no command_name has been set" do
      it "should underscore the class'es name" do
        expect(subject.command_name).to eq('implicit_cmd')
      end
    end

    context "when a command_name is explicitly set" do
      module TestCommandName
        class ExplicitCmd
          include CommandKit::CommandName
          command_name 'explicit'
        end
      end

      subject { TestCommandName::ExplicitCmd }

      it "must return the explicitly set command_name" do
        expect(subject.command_name).to eq('explicit')
      end
    end

    context "when the command class inherites from another class" do
      module TestCommandName
        class BaseCmd
          include CommandKit::CommandName
        end

        class InheritedCmd < BaseCmd
        end
      end

      subject { TestCommandName::InheritedCmd }

      it "should underscore the class'es name" do
        expect(subject.command_name).to eq('inherited_cmd')
      end

      context "when the superclass defines an explicit command_name" do
        module TestCommandName
          class ExplicitBaseCmd
            include CommandKit::CommandName
            command_name :explicit
          end

          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestCommandName::ExplicitBaseCmd }
        subject { TestCommandName::ImplicitInheritedCmd }

        it "must return the subclass'es command_name, not the superclass'es" do
          expect(subject.command_name).to eq('implicit_inherited_cmd')
        end

        it "must not change the superclass'es command_name" do
          expect(super_subject.command_name).to eq('explicit')
        end
      end

      context "when the subclass defines an explicit command_name" do
        module TestCommandName
          class ImplicitBaseCmd
            include CommandKit::CommandName
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            command_name :explicit
          end
        end

        let(:super_subject) { TestCommandName::ImplicitBaseCmd }
        subject { TestCommandName::ExplicitInheritedCmd }

        it "must return the subclass'es command_name, not the superclass'es" do
          expect(subject.command_name).to eq('explicit')
        end

        it "must not change the superclass'es command_name" do
          expect(super_subject.command_name).to eq('implicit_base_cmd')
        end
      end
    end
  end

  describe "#initialize" do
    context "when given no keyword arguments" do
      subject { command_class.new }

      it "must set #command_name to .command_name" do
        expect(subject.command_name).to eq(command_class.command_name)
      end
    end

    context "when given the command_name: keyword argument" do
      let(:command_name) { 'foo' }

      subject { command_class.new(command_name: command_name) }

      it "must set #command_name to the command_name: keyword argument" do
        expect(subject.command_name).to eq(command_name)
      end
    end
  end

  describe "#command_name" do
    let(:command_name) { 'foo' }

    subject { command_class.new(command_name: command_name) }

    it "must return the initialized command_name: value" do
      expect(subject.command_name).to eq(command_name)
    end
  end
end
