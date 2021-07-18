# frozen_string_literal: true

module CommandKit
  #
  # Allows displaying man pages.
  #
  # @since 0.2.0
  #
  module Man
    #
    # Displays the given man page.
    #
    # @param [String] page
    #   The man page file name.
    #
    # @param [Integer, String, nil] section
    #   The optional section number to specify.
    #
    # @return [Boolean, nil]
    #   Specifies whether the `man` command was successful or not.
    #   Returns `nil` when the `man` command is not installed.
    #
    # @api public
    #
    def man(page, section: nil)
      if section
        system('man',section.to_s,page.to_s)
      else
        system('man',page.to_s)
      end
    end
  end
end
