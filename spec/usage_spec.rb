require 'spec_helper'
require 'command_kit/usage'

describe Usage do
  module TestUsage
    class ImplicitCmd
      include CommandKit::Usage
    end
  end

  let(:command_class) { TestUsage::ImplicitCmd }

  describe ".included" do
    it { expect(command_class).to include(CommandKit::CommandName) }
  end

  describe ".usage" do
    subject { TestUsage::ImplicitCmd }

    context "when no usage has been set" do
      it "should default to nil" do
        expect(subject.usage).to be_nil
      end
    end

    context "when a usage is explicitly set" do
      module TestUsage
        class ExplicitCmd
          include CommandKit::Usage
          usage 'EXPLICIT'
        end
      end

      subject { TestUsage::ExplicitCmd }

      it "must return the explicitly set usage" do
        expect(subject.usage).to eq("EXPLICIT")
      end
    end

    context "when the command class inherites from another class" do
      context "but no usage is set" do
        module TestUsage
          class BaseCmd
            include CommandKit::Usage
          end

          class InheritedCmd < BaseCmd
          end
        end

        subject { TestUsage::InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.usage).to be_nil
        end
      end

      module TestUsage
        class ExplicitBaseCmd
          include CommandKit::Usage
          usage 'EXPLICIT'
        end
      end

      context "when the superclass defines an explicit usage" do
        module TestUsage
          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestUsage::ExplicitBaseCmd }
        subject { TestUsage::ImplicitInheritedCmd }

        it "must inherit the superclass'es usage" do
          expect(subject.usage).to eq(super_subject.usage)
        end

        it "must not change the superclass'es usage" do
          expect(super_subject.usage).to eq("EXPLICIT")
        end
      end

      context "when the subclass defines an explicit usage" do
        module TestUsage
          class ImplicitBaseCmd
            include CommandKit::Usage
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            usage 'EXPLICIT'
          end
        end

        let(:super_subject) { TestUsage::ImplicitBaseCmd }
        subject { TestUsage::ExplicitInheritedCmd }

        it "must return the subclass'es usage" do
          expect(subject.usage).to eq("EXPLICIT")
        end

        it "must not change the superclass'es usage" do
          expect(super_subject.usage).to be_nil
        end
      end

      context "when both the subclass overrides the superclass's usages" do
        module TestUsage
          class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
            usage 'EXPLICIT_OVERRIDE'
          end
        end

        let(:super_subject) { TestUsage::ExplicitBaseCmd }
        subject { TestUsage::ExplicitOverridingInheritedCmd }

        it "must return the subclass'es usage" do
          expect(subject.usage).to eq("EXPLICIT_OVERRIDE")
        end

        it "must not change the superclass'es usage" do
          expect(super_subject.usage).to eq("EXPLICIT")
        end
      end
    end
  end

  module TestUsage
    class NoUsage
      include CommandKit::Usage
    end
  end

  module TestUsage
    class SingleUsage
      include CommandKit::Usage

      usage 'ONE USAGE'
    end
  end

  module TestUsage
    class MultipleUsage
      include CommandKit::Usage

      usage [
        'ONE USAGE',
        'TWO USAGE',
        'THREE USAGE'
      ]
    end
  end

  describe "#usage" do
    subject { command_class.new }

    context "when .usage is nil" do
      let(:command_class) { TestUsage::NoUsage }
      subject { command_class.new }

      it "must not print anything" do
        expect(subject.usage).to be(nil)
      end
    end

    context "when .usage is a String" do
      let(:command_class) { TestUsage::SingleUsage }
      subject { command_class.new }

      it "must return .usage, but with #command_name prepended" do
        expect(subject.usage).to eq("#{subject.command_name} #{command_class.usage}")
      end
    end

    context "when #usage is an Array of Strings" do
      let(:command_class) { TestUsage::MultipleUsage }
      subject { command_class.new }

      it "must return .usage, but with #command_name prepended to each element" do
        expect(subject.usage).to eq(
          [
            "#{subject.command_name} #{command_class.usage[0]}",
            "#{subject.command_name} #{command_class.usage[1]}",
            "#{subject.command_name} #{command_class.usage[2]}",
          ]
        )
      end
    end
  end

  describe "#help" do
    context "when #usage is nil" do
      let(:command_class) { TestUsage::NoUsage }
      subject { command_class.new }

      it "must not print anything" do
        expect { subject.help }.to_not output.to_stdout
      end
    end

    context "when #usage is a String" do
      let(:command_class) { TestUsage::SingleUsage }
      subject { command_class.new }

      it "must print out 'usage:' and only one usage" do
        expect { subject.help }.to output(
          "usage: #{subject.usage}#{$/}"
        ).to_stdout
      end
    end

    context "when #usage is an Array of Strings" do
      let(:command_class) { TestUsage::MultipleUsage }
      subject { command_class.new }

      it "must print out the 'usage:' and all usage Strings" do
        expect { subject.help }.to output(
          [
            "usage: #{subject.usage[0]}",
            "       #{subject.usage[1]}",
            "       #{subject.usage[2]}",
            ''
          ].join($/)
        ).to_stdout
      end
    end
  end
end
