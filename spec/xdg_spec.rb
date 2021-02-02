require 'spec_helper'
require 'command_kit/xdg'

describe XDG do
  module TestXDG
    class TestCommand
      include CommandKit::XDG
    end
  end

  let(:command_class) { TestXDG::TestCommand }
  subject { command_class.new }

  let(:xdg_config_home) { '/path/to/.config'      }
  let(:xdg_data_home)   { '/path/to/.local/share' }
  let(:xdg_cache_home)  { '/path/to/.cache'       }

  describe "#initialize" do
    context "when env: contains 'XDG_CONFIG_HOME'" do
      let(:env) do
        {'XDG_CONFIG_HOME' => xdg_config_home}
      end

      subject { command_class.new(env: env) }

      it "must initialize #config_dir" do
        expect(subject.config_dir).to eq(xdg_config_home)
      end
    end

    context "when env: does not contains 'XDG_DATA_HOME'" do
      it "must initialize #config_dir to '$HOME/.config'" do
        expect(subject.config_dir).to eq(File.join(subject.home_dir,'.config'))
      end
    end

    context "when env: contains 'XDG_DATA_HOME'" do
      let(:env) do
        {'XDG_DATA_HOME' => xdg_data_home}
      end

      subject { command_class.new(env: env) }

      it "must initialize #local_share_dir" do
        expect(subject.local_share_dir).to eq(xdg_data_home)
      end
    end

    context "when env: does not contains 'XDG_DATA_HOME'" do
      it "must initialize #local_share_dir to '$HOME/.local/share'" do
        expect(subject.local_share_dir).to eq(File.join(subject.home_dir,'.local','share'))
      end
    end

    context "when env: contains 'XDG_CACHE_HOME'" do
      let(:env) do
        {'XDG_CACHE_HOME' => xdg_cache_home}
      end

      subject { command_class.new(env: env) }

      it "must initialize #cache_dir" do
        expect(subject.cache_dir).to eq(xdg_cache_home)
      end
    end

    context "when env: does not contains 'XDG_CACHE_HOME'" do
      it "must initialize #cache_dir to '$HOME/.cache'" do
        expect(subject.cache_dir).to eq(File.join(subject.home_dir,'.cache'))
      end
    end
  end

  describe "#config_dir" do
    let(:env) do
      {'XDG_CONFIG_HOME' => xdg_config_home}
    end

    subject { command_class.new(env: env) }

    it "must return the initialized #config_dir" do
      expect(subject.config_dir).to eq(xdg_config_home)
    end
  end

  describe "#local_share_dir" do
    let(:env) do
      {'XDG_DATA_HOME' => xdg_data_home}
    end

    subject { command_class.new(env: env) }

    it "must return the initialized #local_share_dir" do
      expect(subject.local_share_dir).to eq(xdg_data_home)
    end
  end

  describe "#cache_dir" do
    let(:env) do
      {'XDG_CACHE_HOME' => xdg_cache_home}
    end

    subject { command_class.new(env: env) }

    it "must return the initialized #cache_dir" do
      expect(subject.cache_dir).to eq(xdg_cache_home)
    end
  end
end
