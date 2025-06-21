require 'spec_helper'
require 'command_kit/colors/plain_text'

describe CommandKit::Colors::PlainText do
  subject { described_class }

  let(:str) { 'foo' }

  [
    :RESET, :CLEAR,
    :BOLD, :RESET_INTENSITY,
    :BLACK, :RED, :GREEN, :YELLOW, :BLUE, :MAGENTA, :CYAN, :WHITE,
    :BRIGHT_BLACK, :BRIGHT_RED, :BRIGHT_GREEN, :BRIGHT_YELLOW, :BRIGHT_BLUE, :BRIGHT_MAGENTA, :BRIGHT_CYAN, :BRIGHT_WHITE,
    :RESET_FG, :RESET_COLOR,
    :ON_BLACK, :ON_RED, :ON_GREEN, :ON_YELLOW, :ON_BLUE, :ON_MAGENTA, :ON_CYAN, :ON_WHITE,
    :ON_BRIGHT_BLACK, :ON_BRIGHT_RED, :ON_BRIGHT_GREEN, :ON_BRIGHT_YELLOW, :ON_BRIGHT_BLUE, :ON_BRIGHT_MAGENTA, :ON_BRIGHT_CYAN, :ON_BRIGHT_WHITE,
    :RESET_BG
  ].each do |const_name|
    describe const_name.to_s do
      it { expect(subject.const_get(const_name)).to eq('') }
    end
  end

  describe ".reset" do
    it { expect(subject.reset).to eq('') }
  end

  describe ".clear" do
    it { expect(subject.clear).to eq('') }
  end

  [
    :bold,
    :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white,
    :bright_black, :gray, :bright_red, :bright_green, :bright_yellow, :bright_blue, :bright_magenta, :bright_cyan, :bright_white,
    :on_black, :on_red, :on_green, :on_yellow, :on_blue, :on_magenta, :on_cyan, :on_white,
    :on_bright_black, :on_gray, :on_bright_red, :on_bright_green, :on_bright_yellow, :on_bright_blue, :on_bright_magenta, :on_bright_cyan, :on_bright_white
  ].each do |method_name|
    describe ".#{method_name}" do
      context "when given a string" do
        it "must return that string" do
          expect(subject.send(method_name,str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.send(method_name)).to eq('') }
      end
    end
  end
end
