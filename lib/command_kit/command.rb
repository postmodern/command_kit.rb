# frozen_string_literal: true

require_relative 'main'
require_relative 'env'
require_relative 'stdio'
require_relative 'printing'
require_relative 'usage'
require_relative 'arguments'
require_relative 'options'
require_relative 'examples'
require_relative 'description'
require_relative 'exception_handler'
require_relative 'file_utils'

module CommandKit
  #
  # The command class base-class.
  #
  # @note
  #   Command classes are not required to inherit from {Command}. If you do not
  #   wish to inherit from the {Command} base class, you can instead include
  #   the individual modules. This class only exists as a convenience.
  #
  # ## Examples
  #
  #     class MyCmd < CommandKit::Command
  #     
  #       usage '[OPTIONS] [-o OUTPUT] FILE'
  #     
  #       option :count, short: '-c',
  #                      value: {
  #                        type: Integer,
  #                        default: 1
  #                      },
  #                      desc: "Number of times"
  #     
  #       option :output, short: '-o',
  #                       value: {
  #                         type: String,
  #                         usage: 'FILE'
  #                       },
  #                       desc: "Optional output file"
  #     
  #       argument :file, required: true,
  #                       usage: 'FILE',
  #                       desc: "Input file"
  #     
  #       examples [
  #         '-o path/to/output.txt path/to/input.txt',
  #         '-v -c 2 -o path/to/output.txt path/to/input.txt',
  #       ]
  #     
  #       description 'Example command'
  #     
  #       def run(*files)
  #         # ...
  #       end
  #     end
  #
  # ### initialize and using instance variables
  #
  #     option :verbose, short: '-v', desc: "Increase verbose level" do
  #       @verbose += 1
  #     end
  # 
  #     def initialize(**kwargs)
  #       super(**kwargs)
  #     
  #       @verbose = 0
  #     end
  #
  # @api public
  #
  class Command

    include Main
    include Env
    include Stdio
    include Printing
    include Help
    include Usage
    include Arguments
    include Options
    include Examples
    include Description
    include ExceptionHandler
    include FileUtils

  end
end
