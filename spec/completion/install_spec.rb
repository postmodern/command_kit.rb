require 'spec_helper'
require 'command_kit/completion/install'

require 'tmpdir'
require 'stringio'

describe CommandKit::Completion::Install do
  module TestCompletionInstall
    class TestCommand
      include CommandKit::Completion::Install
    end
  end

  let(:command_class) { TestCompletionInstall::TestCommand }

  it "must include CommandKit::Printing" do
    expect(command_class).to include(CommandKit::Printing)
  end

  it "must include CommandKit::Env::Shell" do
    expect(command_class).to include(CommandKit::Env::Shell)
  end

  it "must include CommandKit::Env::Prefix" do
    expect(command_class).to include(CommandKit::Env::Prefix)
  end

  let(:shell) { '/bin/bash' }

  subject do
    command_class.new(env: {'SHELL' => shell})
  end

  describe "#completions_dir" do
    context "when env['SHELL'] is a bash shell" do
      let(:shell) { '/bin/bash' }

      context "and the user is a regular user" do
        before { expect(Process).to receive(:uid).and_return(1000) }

        it "must return '~/.local/share/bash/completions/'" do
          expect(subject.completions_dir).to eq(
            File.join(subject.home_dir,'.local','share','bash-completion','completions')
          )
        end
      end

      context "but the user is a root" do
        before { expect(Process).to receive(:uid).and_return(0) }

        it "must return '/usr/local/share/bash-completion/completions'" do
          expect(subject.completions_dir).to eq(
            '/usr/local/share/bash-completion/completions'
          )
        end

        context "and env['PREFIX'] is set" do
          let(:prefix) { '/foo' }

          subject do
            command_class.new(env: {'SHELL' => shell, 'PREFIX' => prefix})
          end

          it "must return '$PREFIX/usr/local/share/bash-completion/completions'" do
            expect(subject.completions_dir).to eq(
              File.join(prefix,'/usr/local/share/bash-completion/completions')
            )
          end
        end
      end
    end

    context "when env['SHELL'] is a zsh shell" do
      let(:shell) { '/bin/zsh' }

      it "must return '/usr/local/share/zsh/site-functions'" do
        expect(subject.completions_dir).to eq(
          '/usr/local/share/zsh/site-functions'
        )
      end

      context "and env['PREFIX'] is set" do
        let(:prefix) { '/foo' }

        subject do
          command_class.new(env: {'SHELL' => shell, 'PREFIX' => prefix})
        end

        it "must return '$PREFIX/usr/local/share/zsh/site-functions'" do
          expect(subject.completions_dir).to eq(
            File.join(prefix,'/usr/local/share/zsh/site-functions')
          )
        end
      end
    end

    context "when env['SHELL'] is a fish shell" do
      let(:shell) { '/bin/fish' }

      context "and the user is a regular user" do
        before { expect(Process).to receive(:uid).and_return(1000) }

        it "must return '~/.config/fish/completions/'" do
          expect(subject.completions_dir).to eq(
            File.join(subject.home_dir,'.config','fish','completions')
          )
        end
      end

      context "but the user is a root" do
        before { expect(Process).to receive(:uid).and_return(0) }

        it "must return '/usr/local/share/fish/completions'" do
          expect(subject.completions_dir).to eq(
            '/usr/local/share/fish/completions'
          )
        end

        context "and env['PREFIX'] is set" do
          let(:prefix) { '/foo' }

          subject do
            command_class.new(env: {'SHELL' => shell, 'PREFIX' => prefix})
          end

          it "must return '$PREFIX/usr/local/share/fish/completions'" do
            expect(subject.completions_dir).to eq(
              File.join(prefix,'/usr/local/share/fish/completions')
            )
          end
        end
      end
    end

    context "but env['SHELL'] is another kind of shell" do
      let(:shell) { '/bin/tcsh' }

      it "must return nil" do
        expect(subject.completions_dir).to be(nil)
      end
    end

    context "but env['SHELL'] cannot be recognized" do
      let(:shell) { '/bin/foo' }

      it "must return nil" do
        expect(subject.completions_dir).to be(nil)
      end
    end

    context "when env['SHELL'] is not set" do
      subject do
        command_class.new(env: {})
      end

      it "must return nil" do
        expect(subject.completions_dir).to be(nil)
      end
    end
  end

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  describe "#print_completion_file" do
    context "when given a bash completion file" do
      let(:file) { File.join(fixtures_dir,'bash','foo') }

      it "must print the contents of the completion file to stdout" do
        expect {
          subject.print_completion_file(file)
        }.to output(File.read(file)).to_stdout
      end

      context "but the env['SHELL'] is zsh" do
        let(:shell) { '/bin/zsh' }

        it "must add the '#compdef command-name-here' magic comments to the output" do
          expect {
            subject.print_completion_file(file)
          }.to output(
            [
              '#compdef foo',
              '',
              File.read(file)
            ].join($/)
          ).to_stdout
        end
      end
    end

    context "when given a zsh completion file" do
      let(:file) { File.join(fixtures_dir,'bash','foo') }

      it "must print the contents of the completion file to stdout" do
        expect {
          subject.print_completion_file(file)
        }.to output(File.read(file)).to_stdout
      end
    end

    context "when given a fish completion file" do
      let(:file) { File.join(fixtures_dir,'fish','foo.fish') }

      it "must print the contents of the completion file to stdout" do
        expect {
          subject.print_completion_file(file)
        }.to output(File.read(file)).to_stdout
      end
    end
  end

  describe "#install_completion_file" do
    let(:output) { StringIO.new }

    context "when env['SHELL'] is a bash shell" do
      let(:shell) { '/bin/bash' }

      context "and the completion file is a bash completion file" do
        let(:completion_file) { File.join(fixtures_dir,'bash','foo') }
        let(:installed_completion_file) do
          File.join(subject.completions_dir,'foo')
        end

        before do
          expect(FileUtils).to receive(:mkdir_p).with(subject.completions_dir)
          expect(File).to receive(:open).with(installed_completion_file,'w').and_yield(output)
          allow(File).to receive(:open).with(completion_file).and_call_original
        end

        it "must install the bash completion file into #completions_dir" do
          subject.install_completion_file(completion_file)

          output.rewind

          expect(output.read).to eq(File.read(completion_file))
        end
      end

      context "but the completion file is a zsh completion file" do
        let(:completion_file) { File.join(fixtures_dir,'zsh','foo') }

        it "must print an error and exit with -1" do
          expect(subject).to receive(:print_error).with("cannot install zsh completion file into the bash shell: #{completion_file}")

          expect {
            subject.install_completion_file(completion_file, type: :zsh)
          }.to raise_error(SystemExit) { |error|
            expect(error.status).to eq(-1)
          }
        end
      end

      context "but the completion file is a fish completion file" do
        let(:completion_file) { File.join(fixtures_dir,'fish','foo') }

        it "must print an error and exit with -1" do
          expect(subject).to receive(:print_error).with("cannot install fish completion file into the bash shell: #{completion_file}")

          expect {
            subject.install_completion_file(completion_file, type: :fish)
          }.to raise_error(SystemExit) { |error|
            expect(error.status).to eq(-1)
          }
        end
      end
    end

    context "when env['SHELL'] is a zsh shell" do
      let(:shell) { '/bin/zsh' }

      context "and the completion file is a zsh completion file" do
        let(:completion_file) { File.join(fixtures_dir,'zsh','_foo') }
        let(:installed_completion_file) do
          File.join(subject.completions_dir,'_foo')
        end

        before do
          expect(FileUtils).to receive(:mkdir_p).with(subject.completions_dir)
          expect(File).to receive(:open).with(installed_completion_file,'w').and_yield(output)
          allow(File).to receive(:open).with(completion_file).and_call_original
        end

        it "must install the zsh completion file into #completions_dir" do
          subject.install_completion_file(completion_file, type: :zsh)

          output.rewind

          expect(output.read).to eq(File.read(completion_file))
        end

        context "when the completion file name does not start with a '_'" do
          let(:completion_file) { File.join(fixtures_dir,'zsh','foo') }

          it "must add a `_` character to the installation completion file's name" do
            subject.install_completion_file(completion_file, type: :zsh)

            output.rewind

            expect(output.read).to eq(File.read(completion_file))
          end
        end
      end

      context "but the completion file is a bash completion file" do
        let(:completion_file) { File.join(fixtures_dir,'zsh','_foo') }
        let(:installed_completion_file) do
          File.join(subject.completions_dir,'_foo')
        end

        before do
          expect(FileUtils).to receive(:mkdir_p).with(subject.completions_dir)
          expect(File).to receive(:open).with(installed_completion_file,'w').and_yield(output)
          allow(File).to receive(:open).with(completion_file).and_call_original
        end

        it "must install the bash completion file into #completions_dir, and add the magic '#compdef command' comments at the top of the installed file" do
          subject.install_completion_file(completion_file)

          output.rewind

          expect(output.read).to eq(
            <<~SHELL
              #compdef foo

              #{File.read(completion_file).chomp}
            SHELL
          )
        end

        context "but the completion file name does not start with a '_'" do
          let(:completion_file) { File.join(fixtures_dir,'zsh','foo') }

          it "must add a `_` character to the installation completion file's name" do
            subject.install_completion_file(completion_file)

            output.rewind

            expect(output.read).to eq(
              <<~SHELL
                #compdef foo

                #{File.read(completion_file).chomp}
              SHELL
            )
          end
        end
      end

      context "but the completion file is a fish completion file" do
        let(:completion_file) { File.join(fixtures_dir,'fish','foo') }

        it "must print an error and exit with -1" do
          expect(subject).to receive(:print_error).with("cannot install fish completion file into the zsh shell: #{completion_file}")

          expect {
            subject.install_completion_file(completion_file, type: :fish)
          }.to raise_error(SystemExit) { |error|
            expect(error.status).to eq(-1)
          }
        end
      end
    end

    context "when env['SHELL'] is a fish shell" do
      let(:shell) { '/bin/fish' }

      context "and the completion file is a fish completion file" do
        let(:installed_completion_file) do
          File.join(subject.completions_dir,'foo.fish')
        end

        context "and when the completion file already has the '.fish' extension" do
          let(:completion_file) { File.join(fixtures_dir,'fish','foo.fish') }

          before do
            expect(FileUtils).to receive(:mkdir_p).with(subject.completions_dir)
            expect(File).to receive(:open).with(installed_completion_file,'w').and_yield(output)
            allow(File).to receive(:open).with(completion_file).and_call_original
          end

          it "must install the bash completion file into #completions_dir" do
            subject.install_completion_file(completion_file, type: :fish)

            output.rewind

            expect(output.read).to eq(File.read(completion_file))
          end
        end

        context "but the completion file name does not have the '.fish' extension" do
          let(:completion_file) { File.join(fixtures_dir,'fish','foo') }

          before do
            expect(FileUtils).to receive(:mkdir_p).with(subject.completions_dir)
            expect(File).to receive(:open).with(installed_completion_file,'w').and_yield(output)
            allow(File).to receive(:open).with(completion_file).and_call_original
          end

          it "must add the '.fish' extension to the installation completion file's name" do
            subject.install_completion_file(completion_file, type: :fish)

            output.rewind

            expect(output.read).to eq(File.read(completion_file))
          end
        end
      end

      context "but the completion file is a bash completion file" do
        let(:completion_file) { File.join(fixtures_dir,'bash','foo') }

        it "must print an error and exit with -1" do
          expect(subject).to receive(:print_error).with("cannot install bash completion file into the fish shell: #{completion_file}")

          expect {
            subject.install_completion_file(completion_file, type: :bash)
          }.to raise_error(SystemExit) { |error|
            expect(error.status).to eq(-1)
          }
        end
      end

      context "and the completion file is a zsh completion file" do
        let(:completion_file) { File.join(fixtures_dir,'zsh','foo') }

        it "must print an error and exit with -1" do
          expect(subject).to receive(:print_error).with("cannot install zsh completion file into the fish shell: #{completion_file}")

          expect {
            subject.install_completion_file(completion_file, type: :zsh)
          }.to raise_error(SystemExit) { |error|
            expect(error.status).to eq(-1)
          }
        end
      end
    end

    context "when env['SHELL'] is another kind of shell" do
      let(:shell)      { '/bin/tcsh' }
      let(:shell_type) { :tcsh }

      let(:completion_file) { File.join(fixtures_dir,'bash','foo') }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("cannot install bash completion file into the #{shell_type} shell: #{completion_file}")

        expect {
          subject.install_completion_file(completion_file)
        }.to raise_error(SystemExit) { |error|
          expect(error.status).to eq(-1)
        }
      end
    end

    context "when env['SHELL'] cannot be recognized" do
      let(:shell) { '/bin/foo' }

      let(:completion_file) { File.join(fixtures_dir,'bash','foo') }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("cannot identify shell: #{shell}")

        expect {
          subject.install_completion_file(completion_file)
        }.to raise_error(SystemExit) { |error|
          expect(error.status).to eq(-1)
        }
      end
    end

    context "but env['SHELL'] is not set" do
      subject do
        command_class.new(env: {})
      end

      let(:completion_file) { File.join(fixtures_dir,'bash','foo') }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("cannot identify shell")

        expect {
          subject.install_completion_file(completion_file)
        }.to raise_error(SystemExit) { |error|
          expect(error.status).to eq(-1)
        }
      end
    end
  end

  describe "#uninstall_completion_file_for" do
    let(:command) { 'foo' }

    context "when env['SHELL'] is a bash shell" do
      it "must remove the completion file with the same name as the command from #completions_dir" do
        expect(FileUtils).to receive(:rm_f).with(
          File.join(subject.completions_dir,command)
        )

        subject.uninstall_completion_file_for(command)
      end
    end

    context "when env['SHELL'] is a zsh shell" do
      let(:shell) { '/bin/zsh' }

      it "must remove the '_command' completion file with the same name as the command from #completions_dir" do
        expect(FileUtils).to receive(:rm_f).with(
          File.join(subject.completions_dir,"_#{command}")
        )

        subject.uninstall_completion_file_for(command)
      end
    end

    context "when env['SHELL'] is a fish shell" do
      let(:shell) { '/bin/fish' }

      it "must remove the 'command.fish' completion file with the same name as the command from #completions_dir" do
        expect(FileUtils).to receive(:rm_f).with(
          File.join(subject.completions_dir,"#{command}.fish")
        )

        subject.uninstall_completion_file_for(command)
      end
    end

    context "but env['SHELL'] is another kind of shell" do
      let(:shell)      { '/bin/tcsh' }
      let(:shell_type) { :tcsh }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("completions not support for the #{shell_type} shell: #{shell}")

        expect {
          subject.uninstall_completion_file_for(command)
        }.to raise_error(SystemExit) { |error|
          expect(error.status).to eq(-1)
        }
      end
    end

    context "but env['SHELL'] cannot be recognized" do
      let(:shell) { '/bin/foo' }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("cannot identify shell: #{shell}")

        expect {
          subject.uninstall_completion_file_for(command)
        }.to raise_error(SystemExit) { |error|
          expect(error.status).to eq(-1)
        }
      end
    end

    context "but env['SHELL'] is not set" do
      subject do
        command_class.new(env: {})
      end

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("cannot identify shell")

        expect {
          subject.uninstall_completion_file_for(command)
        }.to raise_error(SystemExit) { |error|
          expect(error.status).to eq(-1)
        }
      end
    end
  end
end
