require 'fileutils'
require 'erb'

module CommandKit
  #
  # File manipulation related methods.
  #
  # @since 0.3.0
  #
  # @api public
  #
  module FileUtils
    include ::FileUtils

    #
    # Renders an erb file and optionally writes it out to a destination file.
    #
    # @param [String] source
    #   The path to the erb template file.
    #
    # @param [String, nil] dest
    #   The path to the destination file.
    #
    # @return [String, nil]
    #   If no destination path argument is given, the rendered erb template
    #   String will be returned.
    #
    # @example Rendering a ERB template and saving it's output:
    #   erb File.join(template_dir,'README.md.erb'), 'README.md'
    #
    # @example Rendering a ERB template and capturing it's output:
    #   output = erb(File.join(template_dir,'_partial.erb'))
    #
    def erb(source,dest=nil)
      erb    = ERB.new(File.read(source), trim_mode: '-')
      result = erb.result(binding)

      if dest
        File.write(dest,result)
        return
      else
        return result
      end
    end
  end
end
