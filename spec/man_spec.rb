require 'spec_helper'
require 'command_kit/man'

describe CommandKit::Man do
  module TestMan
    class TestCommand
      include CommandKit::Man
    end
  end

  let(:command_class) { TestMan::TestCommand }

  subject { command_class.new }

  describe "#man" do
    let(:man_page) { 'foo' }

    it "must call system() with the given man page" do
      expect(subject).to receive(:system).with('man',man_page)

      subject.man(man_page)
    end

    context "when given a non-String man-page argument" do
      let(:man_page_arg) { double(:non_string_arg) }

      it "must call #to_s on the man-page argument" do
        expect(man_page_arg).to receive(:to_s).and_return(man_page)

        expect(subject).to receive(:system).with('man',man_page)

        subject.man(man_page_arg)
      end
    end

    context "when given the section: keyword argument" do
      let(:section) { 7 }

      it "must call system() with the given section number and man page" do
        expect(subject).to receive(:system).with('man',section.to_s,man_page)

        subject.man(man_page, section: section)
      end
    end
  end
end
