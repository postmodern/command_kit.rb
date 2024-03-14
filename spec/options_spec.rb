require 'spec_helper'
require 'command_kit/options'

describe CommandKit::Options do
  module TestOptions
    class ImplicitCmd
      include CommandKit::Options
    end
  end

  let(:command_class) { TestOptions::ImplicitCmd }
  subject { command_class.new }

  describe ".options" do
    subject { TestOptions::ImplicitCmd }

    context "when no options have been defined" do
      it "should default to {}" do
        expect(subject.options).to eq({})
      end
    end

    context "when a options is explicitly set" do
      module TestOptions
        class ExplicitCmd
          include CommandKit::Options
          option :foo, desc: 'Foo option'
          option :bar, desc: 'Bar option'
        end
      end

      subject { TestOptions::ExplicitCmd }

      it "must return the explicitly set options" do
        expect(subject.options.keys).to eq([:foo, :bar])
      end
    end

    context "when the command class inherites from another class" do
      context "but no options are defined" do
        module TestOptions
          class BaseCmd
            include CommandKit::Options
          end

          class InheritedCmd < BaseCmd
          end
        end

        subject { TestOptions::InheritedCmd }

        it "must search each class then return {}"do
          expect(subject.options).to eq({})
        end
      end

      module TestOptions
        class ExplicitBaseCmd
          include CommandKit::Options
          option :foo, desc: 'Foo option'
          option :bar, desc: 'Bar option'
        end
      end

      context "when the superclass defines options" do
        module TestOptions
          class ImplicitInheritedCmd < ExplicitBaseCmd
          end
        end

        let(:super_subject) { TestOptions::ExplicitBaseCmd }
        subject { TestOptions::ImplicitInheritedCmd }

        it "must inherit the superclass'es options" do
          expect(subject.options).to eq(super_subject.options)
        end

        it "must not change the superclass'es options" do
          expect(super_subject.options.keys).to eq([:foo, :bar])
        end
      end

      context "when the subclass defines options" do
        module TestOptions
          class ImplicitBaseCmd
            include CommandKit::Options
          end

          class ExplicitInheritedCmd < ImplicitBaseCmd
            option :baz, desc: 'Baz option'
            option :qux, desc: 'Qux option'
          end
        end

        let(:super_subject) { TestOptions::ImplicitBaseCmd }
        subject { TestOptions::ExplicitInheritedCmd }

        it "must return the subclass'es options" do
          expect(subject.options.keys).to eq([:baz, :qux])
        end

        it "must not change the superclass'es options" do
          expect(super_subject.options).to eq({})
        end
      end

      context "when subclass overrides the superclass's optionss" do
        module TestOptions
          class ExplicitOverridingInheritedCmd < ExplicitBaseCmd
            option :foo, desc: "Overriden foo option"
          end
        end

        let(:super_subject) { TestOptions::ExplicitBaseCmd }
        subject { TestOptions::ExplicitOverridingInheritedCmd }

        it "must combine the superclass'es options with the subclass'es" do
          expect(subject.options.keys).to eq([:foo, :bar])
          expect(subject.options[:foo].desc).to eq("Overriden foo option")
          expect(subject.options[:bar].desc).to eq("Bar option")
        end

        it "must not change the superclass'es options" do
          expect(super_subject.options.keys).to eq([:foo, :bar])
          expect(super_subject.options[:foo].desc).to eq("Foo option")
          expect(super_subject.options[:bar].desc).to eq("Bar option")
        end
      end
    end
  end

  describe "#initialize" do
    it "must initialize #options" do
      expect(subject.options).to eq({})
    end

    context "when options have default values" do
      module TestOptions
        class TestCommandWithDefaultValues

          include CommandKit::Options

          option :option1, value: {
                             required: true,
                             type: String
                           },
                           desc: 'Option 1'

          option :option2, value: {
                             required: false,
                             type: String,
                             default: "foo"
                           },
                           desc: 'Option 2'
        end
      end

      let(:command_class) { TestOptions::TestCommandWithDefaultValues }

      it "must pre-populate #options with the default values" do
        expect(subject.options).to_not have_key(:option1)
        expect(subject.options).to have_key(:option2)
        expect(subject.options[:option2]).to eq("foo")
      end
    end
  end

  module TestOptions
    class TestCommandWithOptionsAndArguments

      include CommandKit::Options

      usage '[OPTIONS] ARG1 [ARG2]'

      option :option1, short: '-a',
                       value: {
                         type: Integer,
                         default: 1
                       },
                       desc: "Option 1"

      option :option2, short: '-b',
                       value: {
                         type: String,
                         usage: 'FILE'
                       },
                       desc: "Option 2"

      argument :argument1, required: true,
                           usage:    'ARG1',
                           desc:     "Argument 1"

      argument :argument2, required: false,
                           usage:    'ARG2',
                           desc:     "Argument 2"

    end
  end

  describe "#option_parser" do
    context "when an option does not accept a value" do
      module TestOptions
        class TestCommandWithOptionWithoutValue

          include CommandKit::Options

          option :opt, desc: "Option without a value"

        end
      end

      let(:command_class) { TestOptions::TestCommandWithOptionWithoutValue }

      context "but the option flag was not given" do
        let(:argv) { [] }

        before { subject.option_parser.parse(argv) }

        it "must not populate #options with a value" do
          expect(subject.options).to be_empty
        end
      end

      context "and the option flag was given" do
        let(:argv) { %w[--opt] }

        before { subject.option_parser.parse(argv) }

        it "must set a key in #options to true" do
          expect(subject.options[:opt]).to be(true)
        end
      end
    end

    context "when an option requires a value" do
      module TestOptions
        class TestCommandWithOptionWithRequiredValue

          include CommandKit::Options

          option :opt, value: {
                         required: true,
                         type: String
                       },
                       desc: "Option with a value"

        end
      end

      let(:command_class) do
        TestOptions::TestCommandWithOptionWithRequiredValue
      end

      context "but the option flag was not given" do
        let(:argv) { [] }

        before { subject.option_parser.parse(argv) }

        it "must not populate #options with a value" do
          expect(subject.options).to be_empty
        end
      end

      context "and the option flag and value were given" do
        let(:value) { 'foo'            }
        let(:argv)  { ['--opt', value] }

        before { subject.option_parser.parse(argv) }

        it "must set a key in #options to the value" do
          expect(subject.options[:opt]).to eq(value)
        end

        context "and when the option value's type is an Array" do
          module TestOptions
            class TestCommandWithOptionWithArrayType

              include CommandKit::Options

              option :opt, value: {
                             required: true,
                             type: Array
                           },
                           desc: "Option an Array type"

            end
          end

          let(:command_class) { TestOptions::TestCommandWithOptionWithArrayType }

          let(:list)  { %w[a b c] }
          let(:value) { list.join(',') }

          it "must set a key in #options to the parsed list comma separated list of values" do
            expect(subject.options[:opt]).to eq(list)
          end
        end

        context "and when the option value's type is a Regexp" do
          module TestOptions
            class TestCommandWithOptionWithRegexpType

              include CommandKit::Options

              option :opt, value: {
                             required: true,
                             type: /[^=]+=[^=]+/ 
                           },
                           desc: "Option a Regexp type"

            end
          end

          let(:command_class) { TestOptions::TestCommandWithOptionWithRegexpType }

          let(:value) { 'foo=bar' }

          it "must set a key in #options to the matched value" do
            expect(subject.options[:opt]).to eq(value)
          end

          context "and the Regexp contains captures" do
            module TestOptions
              class TestCommandWithOptionWithRegexpTypeWithCaptures

                include CommandKit::Options

                option :opt, value: {
                               required: true,
                               type: /([^=]+)=([^=]+)/ 
                             },
                             desc: "Option a Regexp type and with captures"

              end
            end

            let(:command_class) { TestOptions::TestCommandWithOptionWithRegexpTypeWithCaptures }

            it "must set a key in #options to the matched value, but not the captures" do
              expect(subject.options[:opt]).to eq(value)
            end
          end
        end
      end
    end

    context "when an option does not require a value" do
      module TestOptions
        class TestCommandWithOptionWithOptionalValue

          include CommandKit::Options

          option :opt, value: {
                         required: false,
                         type: String
                       },
                       desc: "Option with an optional value"

        end
      end

      let(:command_class) do
        TestOptions::TestCommandWithOptionWithOptionalValue
      end

      context "but the option flag was not given" do
        let(:argv) { [] }

        before { subject.option_parser.parse(argv) }

        it "must not populate #options with a value" do
          expect(subject.options).to be_empty
        end
      end

      context "and the option flag and value were given" do
        let(:value) { 'foo'            }
        let(:argv)  { ['--opt', value] }

        before { subject.option_parser.parse(argv) }

        it "must set a key in #options to the value" do
          expect(subject.options[:opt]).to eq(value)
        end
      end

      context "and the option has a default value" do
        module TestOptions
          class TestCommandWithOptionWithOptionalValueAndDefaultValue

            include CommandKit::Options

            option :opt, value: {
                           required: false,
                           type: String,
                           default: "bar"
                         },
                         desc: "Option with a default value"

          end
        end

        let(:command_class) do
          TestOptions::TestCommandWithOptionWithOptionalValueAndDefaultValue
        end

        context "but the option flag was not given" do
          let(:argv) { [] }

          before { subject.option_parser.parse(argv) }

          it "must set a key in #options to the default value" do
            expect(subject.options[:opt]).to eq("bar")
          end
        end

        context "and the option flag and value were given" do
          let(:value) { 'foo'            }
          let(:argv)  { ['--opt', value] }

          before { subject.option_parser.parse(argv) }

          it "must set a key in #options to the value" do
            expect(subject.options[:opt]).to eq(value)
          end
        end

        context "and the option flag but not the value are given" do
          let(:argv)  { ['--opt'] }

          before { subject.option_parser.parse(argv) }

          it "must set a key in #options to nil" do
            expect(subject.options).to have_key(:opt)
            expect(subject.options[:opt]).to be(nil)
          end
        end
      end
    end
  end

  describe "#main" do
    let(:command_class) { TestOptions::TestCommandWithOptionsAndArguments }

    let(:argv) { %w[-a 42 -b foo.txt arg1 arg2] }

    it "must parse options before validating the number of arguments" do
      expect {
        expect(subject.main(argv)).to eq(0)
      }.to_not output.to_stderr
    end

    context "but the wrong number of arguments are given" do
      let(:argv) { %w[-a 42 -b foo.txt] }

      it "must still validate the number of arguments" do
        expect {
          expect(subject.main(argv)).to eq(1)
        }.to output("#{subject.command_name}: insufficient number of arguments.#{$/}").to_stderr
      end
    end
  end

  describe "#help" do
    let(:command_class) { TestOptions::TestCommandWithOptionsAndArguments }

    let(:option1)   { command_class.options[:option1]     }
    let(:option2)   { command_class.options[:option2]     }
    let(:argument1) { command_class.arguments[:argument1] }
    let(:argument2) { command_class.arguments[:argument2] }

    it "must print the usage, options and arguments" do
      expect { subject.help }.to output(
        [
          "Usage: #{subject.usage}",
          '',
          'Options:',
          "    #{option1.usage.join(', ').ljust(33 - 1)} #{option1.desc}",
          "    #{option2.usage.join(', ').ljust(33 - 1)} #{option2.desc}",
          '    -h, --help                       Print help information',
          '',
          "Arguments:",
          "    #{argument1.usage.ljust(33)}#{argument1.desc}",
          "    #{argument2.usage.ljust(33)}#{argument2.desc}",
          ''
        ].join($/)
      ).to_stdout
    end

    context "when one of the options has a multi-line description" do
      module TestOptions
        class TestCommandWithMultilineOptionDescription

          include CommandKit::Options

          option :opt1, short: '-a',
                        desc: "Option 1"
          option :opt2, short: '-b',
                        desc: [
                          'Line 1',
                          'Line 2',
                          'Line 3'
                        ]
          option :opt3, short: '-c',
                        desc: "Option 3"

        end
      end

      let(:command_class) { TestOptions::TestCommandWithMultilineOptionDescription }

      let(:option1) { command_class.options[:opt1] }
      let(:option2) { command_class.options[:opt2] }
      let(:option3) { command_class.options[:opt3] }

      it "must indent the multi-line option description" do
        expect { subject.help }.to output(
          [
            "Usage: #{subject.usage}",
            '',
            'Options:',
            "    #{option1.usage.join(', ').ljust(33 - 1)} #{option1.desc}",
            "    #{option2.usage.join(', ').ljust(33 - 1)} #{option2.desc[0]}",
            "    #{option2.desc[1].rjust(39)}",
            "    #{option2.desc[2].rjust(39)}",
            "    #{option3.usage.join(', ').ljust(33 - 1)} #{option3.desc}",
            '    -h, --help                       Print help information',
            ''
          ].join($/)
        ).to_stdout
      end
    end

    context "but when the options are have categories" do
      module TestOptions
        class TestCommandWithOptionsAndCategories

          include CommandKit::Options

          option :opt1, short: '-a',
                        desc: "Option 1"
          option :opt2, short: '-b',
                        desc: "Option 2"

          option :opt3, short:    '-c',
                        desc:     "Option 3",
                        category: 'Other Options'
          option :opt4, short:    '-d',
                        desc:     "Option 4",
                        category: 'Other Options'
        end
      end

      let(:command_class) { TestOptions::TestCommandWithOptionsAndCategories }

      let(:option1)   { command_class.options[:opt1] }
      let(:option2)   { command_class.options[:opt2] }
      let(:option3)   { command_class.options[:opt3] }
      let(:option4)   { command_class.options[:opt4] }

      it "must group the options by category" do
        expect { subject.help }.to output(
          [
            "Usage: #{subject.usage}",
            '',
            'Other Options:',
            "    #{option3.usage.join(', ').ljust(33 - 1)} #{option3.desc}",
            "    #{option4.usage.join(', ').ljust(33 - 1)} #{option4.desc}",
            '',
            'Options:',
            "    #{option1.usage.join(', ').ljust(33 - 1)} #{option1.desc}",
            "    #{option2.usage.join(', ').ljust(33 - 1)} #{option2.desc}",
            '    -h, --help                       Print help information',
            ''
          ].join($/)
        ).to_stdout
      end
    end
  end
end
