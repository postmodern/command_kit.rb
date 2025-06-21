# frozen_string_literal: true

require_relative 'ansi'

module CommandKit
  module Colors
    #
    # Dummy module with the same interface as {ANSI}, but for when ANSI is not
    # supported.
    #
    module PlainText
      ANSI.constants(false).each do |name|
        const_set(name,'')
      end

      module_function

      def reset
        RESET
      end

      def clear
        reset
      end

      [
        :bold,
        :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white,
        :bright_black, :gray, :bright_red, :bright_green, :bright_yellow, :bright_blue, :bright_magenta, :bright_cyan, :bright_white,
        :on_black, :on_red, :on_green, :on_yellow, :on_blue, :on_magenta, :on_cyan, :on_white,
        :on_bright_black, :on_gray, :on_bright_red, :on_bright_green, :on_bright_yellow, :on_bright_blue, :on_bright_magenta, :on_bright_cyan, :on_bright_white
      ].each do |name|
        define_method(name) do |string=nil|
          string || ''
        end
      end
    end
  end
end
