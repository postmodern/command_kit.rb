require_relative 'os'
require_relative 'env/path'

module CommandKit
  #
  # Allows opening a file or a URI with the system's preferred application for
  # that file type or URI scheme.
  #
  # ## Examples
  #
  #     open_app_for "movie.avi"
  #     open_app_for "https://github.com/postmodern/command_kit.rb#readme"
  #
  # @since 0.2.0
  #
  module OpenApp
    include OS
    include Env::Path

    #
    # Initializes the command and determines which open command to use.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @api public
    #
    def initialize(**kwargs)
      super(**kwargs)

      @open_command = if macos?
                        'open'
                      elsif linux? || bsd?
                        if command_installed?('xdg-open')
                          'xdg-open'
                        end
                      elsif windows?
                        if command_installed?('invoke-item')
                          'invoke-item'
                        else
                          'start'
                        end
                      end
    end

    #
    # Opens a file or URI using the system's preferred application for that
    # file type or URI scheme.
    #
    # @param [String, URI] file_or_uri
    #   The file path or URI to open.
    #
    # @return [Boolean, nil]
    #   Specifies whether the file or URI was successfully opened or not.
    #   If the open command could not be determined, `nil` is returned.
    #
    # @example Open a file:
    #   open_app_for "movie.avi"
    #
    # @example Open a URI:
    #   open_app_for "https://github.com/postmodern/command_kit.rb"
    #
    def open_app_for(file_or_uri)
      if @open_command
        system(@open_command,file_or_uri.to_s)
      end
    end
  end
end
