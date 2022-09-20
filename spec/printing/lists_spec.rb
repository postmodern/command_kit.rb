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
