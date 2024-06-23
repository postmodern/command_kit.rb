require 'spec_helper'
require 'command_kit/open'
require 'command_kit/command_name'

describe CommandKit::Open do
  module TestOpen
    class TestCommand
      include CommandKit::CommandName
      include CommandKit::Open

      command_name "test"
    end
  end

  let(:stdin)  { StringIO.new }
  let(:stdout) { StringIO.new }

  let(:test_command) { TestOpen::TestCommand }
  subject { test_command.new(stdin: stdin, stdout: stdout) }

  describe "#open" do
    context "when given a path" do
      context "and the file exists" do
        let(:fixtures_dir) { File.join(__dir__,'fixtures') }
        let(:path)         { File.join(fixtures_dir,'file.txt') }

        context "and a block is given" do
          it "must yield the newly opened file" do
            yielded_file = nil

            subject.open(path) do |file|
              yielded_file = file
            end

            expect(yielded_file).to be_kind_of(File)
            expect(yielded_file.path).to eq(path)
          end
        end

        context "but no block is given" do
          it "must return the newly opened file" do
            file = subject.open(path)

            expect(file).to be_kind_of(File)
            expect(file.path).to eq(path)
          end
        end
      end

      context "but the file does not exist" do
        let(:path) { 'does/not/exist.txt' }

        it "must print an error message and exit with 1" do
          expect {
            subject.open(path)
          }.to output(
            "#{subject.command_name}: No such file or directory: #{path}#{$/}"
          ).to_stderr.and raise_error(SystemExit) { |error|
            expect(error.status).to eq(1)
          }
        end
      end

      context "but when opening the file causes a permission error" do
        let(:path) { '/etc/shadow' }

        before do
          expect(File).to receive(:open).and_raise(Errno::EACCES)
        end

        it "must print an error message and exit with 1" do
          expect {
            subject.open(path)
          }.to output(
            "#{subject.command_name}: Permission denied: #{path}#{$/}"
          ).to_stderr.and raise_error(SystemExit) { |error|
            expect(error.status).to eq(1)
          }
        end
      end
    end

    context "when the given path is '-'" do
      context "and no mode is given" do
        context "and a block is given" do
          it "must yield #stdin" do
            expect { |b|
              subject.open('-',&b)
            }.to yield_with_args(stdin)
          end
        end

        context "but no block is given" do
          it "must return #stdin" do
            expect(subject.open('-')).to be(stdin)
          end
        end
      end

      context "and the mode contains 'r'" do
        context "and a block is given" do
          it "must yield #stdin" do
            expect { |b|
              subject.open('-','rb',&b)
            }.to yield_with_args(stdin)
          end
        end

        context "but no block is given" do
          it "must return #stdin" do
            expect(subject.open('-','rb')).to be(stdin)
          end
        end
      end

      context "and the mode contains 'w'" do
        context "and a block is given" do
          it "must yield #stdout" do
            expect { |b|
              subject.open('-','w',&b)
            }.to yield_with_args(stdout)
          end
        end

        context "but no block is given" do
          it "must return #stdout" do
            expect(subject.open('-','w')).to be(stdout)
          end
        end
      end

      context "and the mode contains 'a'" do
        context "and a block is given" do
          it "must yield #stdout" do
            expect { |b|
              subject.open('-','a',&b)
            }.to yield_with_args(stdout)
          end
        end

        context "but no block is given" do
          it "must return #stdout" do
            expect(subject.open('-','a')).to be(stdout)
          end
        end
      end
    end
  end
end
