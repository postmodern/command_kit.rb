require 'spec_helper'
require 'command_kit/printing/lists'

describe CommandKit::Printing::Lists do
  module TestPrintingLists
    class TestCmd

      include CommandKit::Printing::Lists

    end
  end

  let(:command_class) { TestPrintingLists::TestCmd }
  subject { command_class.new }
  
  describe "#print_list" do
    let(:list) { %w[foo bar baz] }

    it "must print each item in the list with a '*' bullet" do
      expect {
        subject.print_list(list)
      }.to output(
        list.map { |item| "* #{item}" }.join($/) + $/
      ).to_stdout
    end

    context "when the list contins multi-line Strings" do
      let(:item1) { "foo" }
      let(:item2) do
        [
          "line 1",
          "line 2",
          "line 3"
        ].join($/)
      end
      let(:item3) { "bar" }
      let(:list)  { [item1, item2, item3] }

      it "must print the bullet with the first line and then indent the other lines" do
        expect {
          subject.print_list(list)
        }.to output(
          [
            "* #{item1}",
            "* #{item2.lines[0].chomp}",
            "  #{item2.lines[1].chomp}",
            "  #{item2.lines[2].chomp}",
            "* #{item3}",
            ''
          ].join($/)
        ).to_stdout
      end
    end

    context "when the list contains nested-lists" do
      let(:item1)     { 'item 1'     }
      let(:sub_item1) { 'sub-item 1' }
      let(:sub_item2) { 'sub-item 2' }
      let(:item2)     { 'item 2'     }

      let(:list) do
        [
          'item 1',
          [
            'sub-item 1',
            'sub-item 2'
          ],
          'item 2'
        ]
      end

      it "must indent and print each sub-list" do
        expect {
          subject.print_list(list)
        }.to output(
          [
            "* #{item1}",
            "  * #{sub_item1}",
            "  * #{sub_item2}",
            "* #{item2}",
            ''
          ].join($/)
        ).to_stdout
      end
    end
    
    context "when the bullet: keyowrd argument is given" do
      let(:bullet) { '-' }

      it "must print each item in the list with the bullet character" do
        expect {
          subject.print_list(list, bullet: bullet)
        }.to output(
          list.map { |item| "#{bullet} #{item}" }.join($/) + $/
        ).to_stdout
      end
    end
  end
end
