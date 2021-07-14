require 'spec_helper'
require 'command_kit/command'

describe CommandKit::Command do
  it "must include CommandKit::Main" do
    expect(described_class).to include(CommandKit::Main)
  end

  it "must include CommandKit::Env" do
    expect(described_class).to include(CommandKit::Env)
  end

  it "must include CommandKit::Stdio" do
    expect(described_class).to include(CommandKit::Stdio)
  end

  it "must include CommandKit::Printing" do
    expect(described_class).to include(CommandKit::Printing)
  end

  it "must include CommandKit::Help" do
    expect(described_class).to include(CommandKit::Help)
  end

  it "must include CommandKit::Usage" do
    expect(described_class).to include(CommandKit::Usage)
  end

  it "must include CommandKit::Arguments" do
    expect(described_class).to include(CommandKit::Arguments)
  end

  it "must include CommandKit::Options" do
    expect(described_class).to include(CommandKit::Options)
  end

  it "must include CommandKit::Examples" do
    expect(described_class).to include(CommandKit::Examples)
  end

  it "must include CommandKit::Description" do
    expect(described_class).to include(CommandKit::Description)
  end

  it "must include CommandKit::ExceptionHandler" do
    expect(described_class).to include(CommandKit::ExceptionHandler)
  end

  it "must include FileUtils" do
    expect(described_class).to include(FileUtils)
  end
end
