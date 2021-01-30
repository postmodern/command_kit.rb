require 'spec_helper'
require 'command_kit/options'

describe Options do
  class ImplicitCmd
    include CommandKit::Options
  end

  let(:subject_class) { ImplicitCmd }

  describe ".options" do
    subject { ImplicitCmd }

    context "when no options have been defined" do
      it "should default to nil" do
        expect(subject.options).to eq({})
      end
    end

    context "when a options is explicitly set" do
      class ExplicitCmd
        include CommandKit::Options
        option :foo, desc: 'Foo option'
        option :bar, desc: 'Bar option'
      end

      subject { ExplicitCmd }

      it "must return the explicitly set options" do
        expect(subject.options.keys).to eq([:foo, :bar])
      end
    end

    context "when the command class inherites from another class" do
      context "but no options are defined" do
        class BaseCmd
          include CommandKit::Options
        end

        class InheritedCmd < BaseCmd
        end

        subject { InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.options).to eq({})
        end
      end

      class ExplicitBaseCmd
        include CommandKit::Options
        option :foo, desc: 'Foo option'
        option :bar, desc: 'Bar option'
      end

      context "when the superclass defines options" do
        class ImplicitInheritedCmd < ExplicitBaseCmd
        end

        let(:super_subject) { ExplicitBaseCmd }
        subject { ImplicitInheritedCmd }

        it "must inherit the superclass'es options" do
          expect(subject.options).to eq(super_subject.options)
        end

        it "must not change the superclass'es options" do
          expect(super_subject.options.keys).to eq([:foo, :bar])
        end
      end

      context "when the subclass defines options" do
        class ImplicitBaseCmd
          include CommandKit::Options
        end

        class ExplicitInheritedCmd < ImplicitBaseCmd
          option :baz, desc: 'Baz option'
          option :qux, desc: 'Qux option'
        end

        let(:super_subject) { ImplicitBaseCmd }
        subject { ExplicitInheritedCmd }

        it "must return the subclass'es options" do
          expect(subject.options.keys).to eq([:baz, :qux])
        end

        it "must not change the superclass'es options" do
          expect(super_subject.options).to eq({})
        end
      end

      context "when subclass overrides the superclass's optionss" do
        class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
          option :foo, desc: "Overriden foo option"
        end

        let(:super_subject) { ExplicitBaseCmd }
        subject { ExplicitOverridingInheritedCmd }

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
end
