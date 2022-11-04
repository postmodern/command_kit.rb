require 'spec_helper'
require 'command_kit/bug_report'

describe CommandKit::BugReport do
  module TestBugReport
    class CommandWithoutBugReportURLSet
      include CommandKit::BugReport
    end

    class CommandWithBugReportURLSet
      include CommandKit::BugReport

      bug_report_url 'https://github.com/org/repo/issues/new'
    end

    class CommandWithInheritedBugReportURL < CommandWithBugReportURLSet
    end
  end

  let(:command_class) { TestBugReport::CommandWithBugReportURLSet }

  describe ".included" do
    it { expect(command_class).to include(CommandKit::ExceptionHandler) }
    it { expect(command_class).to include(CommandKit::Printing) }
  end

  describe ".bug_report_url" do
    subject { TestBugReport::CommandWithoutBugReportURLSet }

    context "when no bug_report_url has been set" do
      it "should default to nil" do
        expect(subject.bug_report_url).to be_nil
      end
    end

    context "when a bug_report_url is explicitly set" do
      subject { TestBugReport::CommandWithBugReportURLSet }

      it "must return the explicitly set bug_report_url" do
        expect(subject.bug_report_url).to eq("https://github.com/org/repo/issues/new")
      end
    end

    context "when the command class inherites from another class" do
      context "but no bug_report_url is set" do
        module TestBugReport
          class BaseCmd
            include CommandKit::BugReport
          end

          class InheritedCmd < BaseCmd
          end
        end

        subject { TestBugReport::InheritedCmd }

        it "must search each class then return nil "do
          expect(subject.bug_report_url).to be_nil
        end
      end

      module TestBugReport
        class ExplicitBaseCmd
          include CommandKit::BugReport
          bug_report_url 'https://github.com/org/repo/issues/new'
        end
      end

      context "when the superclass defines an explicit bug_report_url" do
        module TestBugReport
          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestBugReport::ExplicitBaseCmd }
        subject { TestBugReport::ImplicitInheritedCmd }

        it "must inherit the superclass'es bug_report_url" do
          expect(subject.bug_report_url).to eq(super_subject.bug_report_url)
        end

        it "must not change the superclass'es bug_report_url" do
          expect(super_subject.bug_report_url).to eq('https://github.com/org/repo/issues/new')
        end
      end

      context "when the subclass defines an explicit bug_report_url" do
        module TestBugReport
          class ImplicitBaseCmd
            include CommandKit::BugReport
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            bug_report_url 'https://github.com/other_org/other_repo/issues/new'
          end
        end

        let(:super_subject) { TestBugReport::ImplicitBaseCmd }
        subject { TestBugReport::ExplicitInheritedCmd }

        it "must return the subclass'es bug_report_url" do
          expect(subject.bug_report_url).to eq('https://github.com/other_org/other_repo/issues/new')
        end

        it "must not change the superclass'es bug_report_url" do
          expect(super_subject.bug_report_url).to be_nil
        end
      end

      context "when both the subclass overrides the superclass's bug_report_urls" do
        module TestBugReport
          class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
            bug_report_url 'https://github.com/other_org/other_repo/issues/new'
          end
        end

        let(:super_subject) { TestBugReport::ExplicitBaseCmd }
        subject { TestBugReport::ExplicitOverridingInheritedCmd }

        it "must return the subclass'es bug_report_url" do
          expect(subject.bug_report_url).to eq("https://github.com/other_org/other_repo/issues/new")
        end

        it "must not change the superclass'es bug_report_url" do
          expect(super_subject.bug_report_url).to eq("https://github.com/org/repo/issues/new")
        end
      end
    end
  end

  subject { command_class.new }

  describe "#bug_report_url" do
    context "when the command has bug_report_url set" do
      let(:command_class) { TestBugReport::CommandWithBugReportURLSet }

      it "must return the bug_report_url" do
        expect(subject.bug_report_url).to eq(command_class.bug_report_url)
      end
    end

    context "when the command does not have bug_report_url set" do
      let(:command_class) { TestBugReport::CommandWithoutBugReportURLSet }

      it "must return nil" do
        expect(subject.bug_report_url).to be(nil)
      end
    end
  end

  describe "#print_bug_report" do
    let(:message) { "error!" }
    let(:backtrace) do
      [
        "/path/to/test1.rb:1 in `test1'",
        "/path/to/test2.rb:2 in `test2'",
        "/path/to/test3.rb:3 in `test3'",
        "/path/to/test4.rb:4 in `test4'"
      ]
    end
    let(:exception) do
      error = RuntimeError.new(message)
      error.set_backtrace(backtrace)
      error
    end

    subject { command_class.new(stderr: StringIO.new) }

    context "when the command has bug_report_url set" do
      let(:command_class) { TestBugReport::CommandWithBugReportURLSet }

      context "when stderr is a TTY" do
        before { expect(subject.stderr).to receive(:tty?).and_return(true) }

        it "must print a message, bug_report_url, and a highlighted exception" do
          subject.print_bug_report(exception)

          expect(subject.stderr.string).to eq(
            [
              '',
              'Oops! Looks like you have found a bug. Please report it!',
              command_class.bug_report_url,
              '',
              '```',
              exception.full_message(highlight: true).chomp,
              '```',
              ''
            ].join($/)
          )
        end
      end

      context "when stderr is not a TTY" do
        it "must print a message, bug_report_url, and print an unhighlighted exception" do
          subject.print_bug_report(exception)

          expect(subject.stderr.string).to eq(
            [
              '',
              'Oops! Looks like you have found a bug. Please report it!',
              command_class.bug_report_url,
              '',
              '```',
              exception.full_message(highlight: false).chomp,
              '```',
              ''
            ].join($/)
          )
        end
      end
    end

    context "when the command does not have bug_report_url set" do
      let(:command_class) { TestBugReport::CommandWithoutBugReportURLSet }

      context "when stderr is a TTY" do
        before { expect(subject.stderr).to receive(:tty?).and_return(true) }

        it "must print a message and a highlighted exception" do
          subject.print_bug_report(exception)

          expect(subject.stderr.string).to eq(
            [
              '',
              'Oops! Looks like you have found a bug. Please report it!',
              '',
              '```',
              exception.full_message(highlight: true).chomp,
              '```',
              ''
            ].join($/)
          )
        end
      end

      context "when stderr is not a TTY" do
        it "must print a message and print an unhighlighted exception" do
          subject.print_bug_report(exception)

          expect(subject.stderr.string).to eq(
            [
              '',
              'Oops! Looks like you have found a bug. Please report it!',
              '',
              '```',
              exception.full_message(highlight: false).chomp,
              '```',
              ''
            ].join($/)
          )
        end
      end
    end
  end

  describe "#on_exception" do
    let(:exception) { RuntimeError.new('error!') }

    it "must call print_bug_report with the exception and then exit(-1)" do
      expect(subject).to receive(:print_bug_report).with(exception)
      expect(subject).to receive(:exit).with(-1)

      subject.on_exception(exception)
    end
  end
end
