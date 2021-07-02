require 'spec_helper'
require 'command_kit/xdg'

describe CommandKit::XDG do
  module TestXDG
    class TestCommand
      include CommandKit::XDG
    end
  end

  let(:command_class) { TestXDG::TestCommand }
  subject { command_class.new }

  describe ".xdg_namespace" do
    subject { command_class }

    context "when no xdg_namespace has been defined" do
      it "must default to the .command_name" do
        expect(subject.xdg_namespace).to eq(subject.command_name)
      end
    end

    context "when an xdg_namespace has been defined in a super-class" do
      module TestXDG
        class SuperClassWithXDGNamespace
          include CommandKit::XDG

          xdg_namespace 'foo'
        end

        class SubClassWithoutXDGNamespace < SuperClassWithXDGNamespace
        end
      end

      let(:command_superclass) { TestXDG::SuperClassWithXDGNamespace }
      let(:command_class) { TestXDG::SubClassWithoutXDGNamespace }

      it "must default to the superclass'es .xdg_namespace" do
        expect(subject.xdg_namespace).to eq(command_superclass.xdg_namespace)
      end

      context "but the sub-class also defines an .xdg_namespace" do
        module TestXDG
          class SubClassWithXDGNamespace < SuperClassWithXDGNamespace

            xdg_namespace 'bar'

          end
        end

        let(:command_class) { TestXDG::SubClassWithXDGNamespace }

        it "must return the subclass'es .xdg_namespace" do
          expect(command_class.xdg_namespace).to eq('bar')
        end

        it "must not override the superclass'es .xdg_namespace" do
          expect(command_superclass.xdg_namespace).to eq('foo')
        end
      end
    end
  end
  
  describe "#xdg_namespace" do
    it "must return .xdg_namespace" do
      expect(subject.xdg_namespace).to eq(command_class.xdg_namespace)
    end
  end

  let(:xdg_config_home) { '/path/to/.config'      }
  let(:xdg_data_home)   { '/path/to/.local/share' }
  let(:xdg_cache_home)  { '/path/to/.cache'       }

  describe "#initialize" do
    let(:xdg_namespace) { subject.xdg_namespace }

    context "when env: contains 'XDG_CONFIG_HOME'" do
      let(:env) do
        {'XDG_CONFIG_HOME' => xdg_config_home}
      end

      subject { command_class.new(env: env) }

      it "must initialize #config_dir to '$XDG_CONFIG_HOME/<xdg_namespace>'" do
        expect(subject.config_dir).to eq(
          File.join(xdg_config_home,xdg_namespace)
        )
      end
    end

    context "when env: does not contains 'XDG_DATA_HOME'" do
      it "must initialize #config_dir to '$HOME/.config/<xdg_namespace>'" do
        expect(subject.config_dir).to eq(
          File.join(subject.home_dir,'.config',subject.xdg_namespace)
        )
      end
    end

    context "when env: contains 'XDG_DATA_HOME'" do
      let(:env) do
        {'XDG_DATA_HOME' => xdg_data_home}
      end

      subject { command_class.new(env: env) }

      it "must initialize #local_share_dir to '$XDG_DATA_HOME/<xdg_namespace>'" do
        expect(subject.local_share_dir).to eq(
          File.join(xdg_data_home,xdg_namespace)
        )
      end
    end

    context "when env: does not contains 'XDG_DATA_HOME'" do
      it "must initialize #local_share_dir to '$HOME/.local/share/<xdg_namespace>'" do
        expect(subject.local_share_dir).to eq(
          File.join(subject.home_dir,'.local','share',xdg_namespace)
        )
      end
    end

    context "when env: contains 'XDG_CACHE_HOME'" do
      let(:env) do
        {'XDG_CACHE_HOME' => xdg_cache_home}
      end

      subject { command_class.new(env: env) }

      it "must initialize #cache_dir to '$XDG_CACHE_HOME/<xdg_namespace>'" do
        expect(subject.cache_dir).to eq(
          File.join(xdg_cache_home,xdg_namespace)
        )
      end
    end

    context "when env: does not contains 'XDG_CACHE_HOME'" do
      it "must initialize #cache_dir to '$HOME/.cache/<xdg_namespace>'" do
        expect(subject.cache_dir).to eq(
          File.join(subject.home_dir,'.cache',xdg_namespace)
        )
      end
    end
  end

  describe "#config_dir" do
    let(:env) do
      {'XDG_CONFIG_HOME' => xdg_config_home}
    end

    subject { command_class.new(env: env) }

    let(:xdg_namespace) { subject.xdg_namespace }

    it "must return the initialized #config_dir" do
      expect(subject.config_dir).to eq(
        File.join(xdg_config_home,xdg_namespace)
      )
    end
  end

  describe "#local_share_dir" do
    let(:env) do
      {'XDG_DATA_HOME' => xdg_data_home}
    end

    subject { command_class.new(env: env) }

    let(:xdg_namespace) { subject.xdg_namespace }

    it "must return the initialized #local_share_dir" do
      expect(subject.local_share_dir).to eq(
        File.join(xdg_data_home,xdg_namespace)
      )
    end
  end

  describe "#cache_dir" do
    let(:env) do
      {'XDG_CACHE_HOME' => xdg_cache_home}
    end

    subject { command_class.new(env: env) }

    let(:xdg_namespace) { subject.xdg_namespace }

    it "must return the initialized #cache_dir" do
      expect(subject.cache_dir).to eq(
        File.join(xdg_cache_home,xdg_namespace)
      )
    end
  end
end
