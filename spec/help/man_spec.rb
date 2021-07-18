require 'spec_helper'
require 'command_kit/help/man'

describe CommandKit::Help::Man do
  module TestHelpMan
    class TestCommand
      include CommandKit::Help::Man

      man_dir "#{__dir__}/fixtures/man"
    end

    class TestCommandWithManPage
      include CommandKit::Help::Man

      man_dir "#{__dir__}/fixtures/man"
      man_page 'foo.1'
    end

    class EmptyCommand
      include CommandKit::Help::Man
    end
  end

  let(:command_class) { TestHelpMan::TestCommand }

  describe ".included" do
    subject { command_class }

    it "must include CommandName" do
      expect(subject).to include(CommandKit::CommandName)
    end

    it "must include Help" do
      expect(subject).to include(CommandKit::Help)
    end

    it "must include Stdio" do
      expect(subject).to include(CommandKit::Stdio)
    end
  end

  describe ".man_dir" do
    context "when no man_dir have been set" do
      subject { TestHelpMan::EmptyCommand }

      it "should default to nil" do
        expect(subject.man_dir).to be_nil
      end
    end

    context "when a man_dir is explicitly set" do
      subject { TestHelpMan::TestCommand }

      it "must return the explicitly set man_dir" do
        expect(subject.man_dir).to eq(File.expand_path('../fixtures/man',__FILE__))
      end
    end

    context "when the command class inherites from another class" do
      context "but no man_dir is set" do
        module TestHelpMan
          class BaseCmd
            include CommandKit::Help::Man
          end

          class InheritedCmd < BaseCmd
          end
        end

        subject { TestHelpMan::InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.man_dir).to be_nil
        end
      end

      module TestHelpMan
        class ExplicitBaseCmd
          include CommandKit::Help::Man

          man_dir 'set/in/baseclass'
        end
      end

      context "when the superclass defines an explicit man_dir" do
        module TestHelpMan
          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestHelpMan::ExplicitBaseCmd }
        subject { TestHelpMan::ImplicitInheritedCmd }

        it "must inherit the superclass'es man_dir" do
          expect(subject.man_dir).to eq(super_subject.man_dir)
        end

        it "must not change the superclass'es man_dir" do
          expect(super_subject.man_dir).to eq('set/in/baseclass')
        end
      end

      context "when the subclass defines an explicit man_dir" do
        module TestHelpMan
          class ImplicitBaseCmd
            include CommandKit::Help::Man
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            man_dir 'set/in/subclass'
          end
        end

        let(:super_subject) { TestHelpMan::ImplicitBaseCmd }
        subject { TestHelpMan::ExplicitInheritedCmd }

        it "must return the subclass'es man_dir" do
          expect(subject.man_dir).to eq('set/in/subclass')
        end

        it "must not change the superclass'es man_dir" do
          expect(super_subject.man_dir).to be_nil
        end
      end

      context "when both the subclass overrides the superclass's man_dirs" do
        module TestHelpMan
          class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
            man_dir 'set/in/subclass'
          end
        end

        let(:super_subject) { TestHelpMan::ExplicitBaseCmd }
        subject { TestHelpMan::ExplicitOverridingInheritedCmd }

        it "must return the subclass'es man_dir" do
          expect(subject.man_dir).to eq('set/in/subclass')
        end

        it "must not change the superclass'es man_dir" do
          expect(super_subject.man_dir).to eq('set/in/baseclass')
        end
      end
    end
  end

  describe ".man_page" do
    context "when no man_page has been set" do
      subject { TestHelpMan::TestCommand }

      it "should default to \"\#{command_name}.1\"" do
        expect(subject.man_page).to eq("#{subject.command_name}.1")
      end
    end

    context "when a man_page is explicitly set" do
      module TestHelpMan
        class ExplicitCmd
          include CommandKit::Help::Man
          man_page 'explicit.1'
        end
      end

      subject { TestHelpMan::ExplicitCmd }

      it "must return the explicitly set man_page" do
        expect(subject.man_page).to eq('explicit.1')
      end
    end

    context "when the command class inherites from another class" do
      module TestHelpMan
        class BaseCmd
          include CommandKit::Help::Man
        end

        class InheritedCmd < BaseCmd
        end
      end

      subject { TestHelpMan::InheritedCmd }

      it "should underscore the class'es name" do
        expect(subject.man_page).to eq('inherited_cmd.1')
      end

      context "when the superclass defines an explicit man_page" do
        module TestHelpMan
          class ExplicitBaseCmd
            include CommandKit::Help::Man
            man_page 'explicit.1'
          end

          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestHelpMan::ExplicitBaseCmd }
        subject { TestHelpMan::ImplicitInheritedCmd }

        it "must return the subclass'es man_page, not the superclass'es" do
          expect(subject.man_page).to eq('implicit_inherited_cmd.1')
        end

        it "must not change the superclass'es man_page" do
          expect(super_subject.man_page).to eq('explicit.1')
        end
      end

      context "when the subclass defines an explicit man_page" do
        module TestHelpMan
          class ImplicitBaseCmd
            include CommandKit::Help::Man
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            man_page 'explicit.1'
          end
        end

        let(:super_subject) { TestHelpMan::ImplicitBaseCmd }
        subject { TestHelpMan::ExplicitInheritedCmd }

        it "must return the subclass'es man_page, not the superclass'es" do
          expect(subject.man_page).to eq('explicit.1')
        end

        it "must not change the superclass'es man_page" do
          expect(super_subject.man_page).to eq('implicit_base_cmd.1')
        end
      end
    end
  end

  subject { command_class.new }

  describe "#help_man" do
    context "when .man_dir is not set" do
      let(:command_class) { TestHelpMan::EmptyCommand }
      subject { command_class.new }

      it do
        expect { subject.help_man }.to raise_error(NotImplementedError)
      end
    end

    let(:man_page_path) do
      File.join(subject.class.man_dir,subject.class.man_page)
    end

    it "must open the .man_page within the .man_dir" do
      expect(subject).to receive(:system).with('man',man_page_path)

      subject.help_man
    end

    context "when given a custom man page" do
      let(:man_page)      { 'bar.1' }
      let(:man_page_path) { File.join(subject.class.man_dir,man_page) }

      it "must open the custom man-page within the .man_dir" do
        expect(subject).to receive(:system).with('man',man_page_path)

        subject.help_man(man_page)
      end
    end
  end

  describe "#help" do
    let(:normal_help_output) do
      stdout = StringIO.new

      command_class.new(stdout: stdout).tap do |command|
        command.method(:help).super_method.call
      end

      stdout.string
    end

    let(:stdout) { StringIO.new }

    subject { command_class.new(stdout: stdout) }

    context "when stdout is a TTY" do
      before do
        expect(subject.stdout).to receive(:tty?).and_return(true)
      end

      it "must open the command's man-page" do
        expect(subject).to receive(:help_man).and_return(true)

        subject.help
      end

      context "but when the man command is not installed" do
        before do
          expect(subject).to receive(:help_man).and_return(nil)
        end

        it "must call the super help() method" do
          subject.help

          expect(subject.stdout.string).to eq(normal_help_output)
        end
      end
    end

    context "when stdout is not a TTY" do
      it "must call the super help() method" do
        subject.help

        expect(stdout.string).to eq(normal_help_output)
      end
    end
  end
end
