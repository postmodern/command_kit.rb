# frozen_string_literal: true
require 'spec_helper'
require 'command_kit/printing/tables/border_style'

describe CommandKit::Printing::Tables::BorderStyle do
  describe "#initialize" do
    [
      :top_left_corner,
      :top_border,
      :top_joined_border,
      :top_right_corner,
      :left_border,
      :left_joined_border,
      :horizontal_separator,
      :vertical_separator,
      :inner_joined_border,
      :right_border,
      :right_joined_border,
      :bottom_border,
      :bottom_left_corner,
      :bottom_joined_border,
      :bottom_right_corner
    ].each do |keyword|
      context "when #{keyword}: keyword is given" do
        let(:keyword) { keyword }
        let(:value)   { 'x' }

        subject { described_class.new(**{keyword => value}) }

        it "must set ##{keyword}" do
          expect(subject.send(keyword)).to eq(value)
        end
      end

      context "when #{keyword}: keyword is not given" do
        let(:keyword) { keyword }

        it "must default ##{keyword} to ' '" do
          expect(subject.send(keyword)).to eq(' ')
        end
      end
    end
  end
end
