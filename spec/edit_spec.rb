require 'spec_helper'
require 'command_kit/edit'

describe CommandKit::Edit do
  module TestEdit
    class TestCommand
      include CommandKit::Edit
    end
  end

  let(:command_class) { TestEdit::TestCommand }

  it "must also include CommandKit::Env" do
    expect(command_class).to include(CommandKit::Env)
  end

  describe "#editor" do
    subject { command_class.new(env: env) }

    context "when env['EDITOR'] is set" do
      let(:editor) { 'vim' }
      let(:env) do
        {'EDITOR' => editor}
      end

      it "must return env['EDITOR']" do
        expect(subject.editor).to eq(env['EDITOR'])
      end
    end

    context "when env['EDITOR'] is not set" do
      let(:env) do
        {}
      end

      it "must return 'nano'" do
        expect(subject.editor).to eq('nano')
      end
    end
  end

  describe "#edit" do
    subject { command_class.new(env: env) }

    let(:arguments) { ['file.txt'] }

    context "when env['EDITOR'] is set" do
      let(:editor) { 'vim' }
      let(:env) do
        {'EDITOR' => editor}
      end

      it "must invoke system with #editor and the additional arguments" do
        expect(subject).to receive(:system).with(subject.editor,*arguments)

        subject.edit(*arguments)
      end
    end

    context "when env['EDITOR'] is not set" do
      let(:env) do
        {}
      end

      it "must invoke system with 'nano' and the additional arguments" do
        expect(subject).to receive(:system).with('nano',*arguments)

        subject.edit(*arguments)
      end
    end
  end
end
