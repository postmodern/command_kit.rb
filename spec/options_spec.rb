require 'spec_helper'
require 'command_kit/options'

describe Options do
  module TestOptions
    class ImplicitCmd
      include CommandKit::Options
    end
  end

  let(:subject_class) { TestOptions::ImplicitCmd }
  subject { subject_class.new }

  describe ".options" do
    subject { TestOptions::ImplicitCmd }

    context "when no options have been defined" do
      it "should default to nil" do
        expect(subject.options).to eq({})
      end
    end

    context "when a options is explicitly set" do
      module TestOptions
        class ExplicitCmd
          include CommandKit::Options
          option :foo, desc: 'Foo option'
          option :bar, desc: 'Bar option'
        end
      end

      subject { TestOptions::ExplicitCmd }

      it "must return the explicitly set options" do
        expect(subject.options.keys).to eq([:foo, :bar])
      end
    end

    context "when the command class inherites from another class" do
      context "but no options are defined" do
        module TestOptions
          class BaseCmd
            include CommandKit::Options
          end

          class InheritedCmd < BaseCmd
          end
        end

        subject { TestOptions::InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.options).to eq({})
        end
      end

      module TestOptions
        class ExplicitBaseCmd
          include CommandKit::Options
          option :foo, desc: 'Foo option'
          option :bar, desc: 'Bar option'
        end
      end

      context "when the superclass defines options" do
        module TestOptions
          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestOptions::ExplicitBaseCmd }
        subject { TestOptions::ImplicitInheritedCmd }

        it "must inherit the superclass'es options" do
          expect(subject.options).to eq(super_subject.options)
        end

        it "must not change the superclass'es options" do
          expect(super_subject.options.keys).to eq([:foo, :bar])
        end
      end

      context "when the subclass defines options" do
        module TestOptions
          class ImplicitBaseCmd
            include CommandKit::Options
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            option :baz, desc: 'Baz option'
            option :qux, desc: 'Qux option'
          end
        end

        let(:super_subject) { TestOptions::ImplicitBaseCmd }
        subject { TestOptions::ExplicitInheritedCmd }

        it "must return the subclass'es options" do
          expect(subject.options.keys).to eq([:baz, :qux])
        end

        it "must not change the superclass'es options" do
          expect(super_subject.options).to eq({})
        end
      end

      context "when subclass overrides the superclass's optionss" do
        module TestOptions
          class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
            option :foo, desc: "Overriden foo option"
          end
        end

        let(:super_subject) { TestOptions::ExplicitBaseCmd }
        subject { TestOptions::ExplicitOverridingInheritedCmd }

        it "must combine the superclass'es options with the subclass'es" do
          expect(subject.options.keys).to eq([:foo, :bar])
          expect(subject.options[:foo].desc).to eq("Overriden foo option")
          expect(subject.options[:bar].desc).to eq("Bar option")
        end

        it "must not change the superclass'es options" do
          expect(super_subject.options.keys).to eq([:foo, :bar])
          expect(super_subject.options[:foo].desc).to eq("Foo option")
          expect(super_subject.options[:bar].desc).to eq("Bar option")
        end
      end
    end
  end

  describe "#initialize" do
    it "must initialize #options" do
      expect(subject.options).to eq({})
    end
  end
end
