require 'spec_helper'
require 'command_kit/options/version'

require 'stringio'

describe CommandKit::Options::Version do
  module TestOptionsVersion
    class TestCommandWithoutVersion

      include CommandKit::Options::Version

      command_name 'test'

    end

    class TestCommandWithVersion

      include CommandKit::Options::Version

      command_name 'test'
      version '0.1.0'

    end
  end

  describe ".included" do
    subject { TestOptionsVersion::TestCommandWithVersion }

    it "must include CommandKit::Options" do
      expect(subject).to include(CommandKit::Options)
    end
  end

  describe ".version" do
    context "when no .version has been previously set" do
      subject { TestOptionsVersion::TestCommandWithoutVersion }

      it "must return nil" do
        expect(subject.version).to be(nil)
      end
    end

    context "when a .version has been set" do
      subject { TestOptionsVersion::TestCommandWithVersion }

      it "must return the set version" do
        expect(subject.version).to eq('0.1.0')
      end
    end

    context "when the command class inherites from another class" do
      context "but no version are defined" do
        module TestOptionsVersion
          class InheritedCommandWithoutVersion < TestCommandWithoutVersion
          end
        end

        subject { TestOptionsVersion::InheritedCommandWithoutVersion }

        it "must return nil" do
          expect(subject.version).to be(nil)
        end
      end

      context "when the superclass defines the version" do
        module TestOptionsVersion
          class InheritedCommandWithInheritedVersion < TestCommandWithVersion
          end
        end

        let(:super_class) { TestOptionsVersion::TestCommandWithVersion }
        subject { TestOptionsVersion::InheritedCommandWithInheritedVersion }

        it "must return the version defined in the superclass" do
          expect(subject.version).to eq(super_class.version)
        end
      end

      context "when the subclass defines the version" do
        module TestOptionsVersion
          class InheritedCommandWithOwnVersion < TestCommandWithoutVersion

            version '0.1.0'

          end
        end

        let(:super_subject) { TestOptionsVersion::TestCommandWithoutVersion }
        subject { TestOptionsVersion::InheritedCommandWithOwnVersion }

        it "must return the version set in the subclass" do
          expect(subject.version).to eq('0.1.0')
        end

        it "must not change the superclass'es version" do
          expect(super_subject.version).to be(nil)
        end
      end

      context "when subclass overrides the superclass's version" do
        module TestOptionsVersion
          class InheritedCommandThatOverridesVersion < TestCommandWithVersion

            version '0.2.0'

          end
        end

        let(:super_subject) { TestOptionsVersion::TestCommandWithVersion }
        subject { TestOptionsVersion::InheritedCommandThatOverridesVersion }

        it "must return the version set in the subclass" do
          expect(subject.version).to eq('0.2.0')
        end

        it "must not change the superclass'es version" do
          expect(super_subject.version).to eq('0.1.0')
        end
      end
    end
  end

  let(:command_class) { TestOptionsVersion::TestCommandWithVersion }

  subject { command_class.new }

  describe "#version" do
    it "must return the class'es .version value" do
      expect(subject.version).to eq(command_class.version)
    end
  end

  describe "#print_version" do
    let(:stdout) { StringIO.new }

    subject { command_class.new(stdout: stdout) }

    it "must print the #command_name and #version" do
      subject.print_version

      expect(stdout.string).to eq(
        "#{subject.command_name} #{subject.version}#{$/}"
      )
    end
  end
end
