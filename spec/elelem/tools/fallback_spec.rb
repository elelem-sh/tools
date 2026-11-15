# frozen_string_literal: true

RSpec.describe "the grep and glob fallbacks" do
  # A PATH with bash and the fallbacks, but no rg or fd.
  around do |example|
    original = ENV.fetch("PATH")
    Dir.mktmpdir do |dir|
      bin = File.join(dir, "bin")
      Dir.mkdir(bin)
      %w[bash grep find].each do |cmd|
        found = ENV.fetch("PATH").split(":").map { |d| File.join(d, cmd) }.find { |f| File.executable?(f) }
        File.symlink(found, File.join(bin, cmd))
      end
      File.write(File.join(dir, "notes.txt"), "needle\n")
      ENV["PATH"] = bin
      @bin = bin
      Dir.chdir(dir) { example.run }
    ensure
      ENV["PATH"] = original
    end
  end

  it "falls back when rg is there but cannot run" do
    File.binwrite(File.join(@bin, "rg"), "\x7FELF\x00\x00")
    File.chmod(0o755, File.join(@bin, "rg"))
    result = run_tool("grep", { "pattern" => "needle" })

    expect(result[:content]).to include("notes.txt")
  end

  it "does not fall back when rg runs and finds nothing" do
    File.write(File.join(@bin, "rg"), "#!/bin/sh\nexit 1\n")
    File.chmod(0o755, File.join(@bin, "rg"))
    result = run_tool("grep", { "pattern" => "needle" })

    expect([result[:exit_status], result[:content]]).to eq([1, "no matches"])
    expect(result).to be_ok
  end

  it "greps with grep when rg is not installed" do
    result = run_tool("grep", { "pattern" => "needle" })

    expect(result[:exit_status]).to eq(0)
    expect(result[:content]).to include("notes.txt")
  end

  it "globs with find when fd is not installed" do
    result = run_tool("glob", { "pattern" => "*.txt" })

    expect(result[:exit_status]).to eq(0)
    expect(result[:content]).to include("notes.txt")
  end
end
