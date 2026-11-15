# frozen_string_literal: true

RSpec.describe "the grep and glob fallbacks" do
  # A PATH with bash and the fallbacks, but no rg or fd.
  around do |example|
    Dir.mktmpdir do |dir|
      bin = File.join(dir, "bin")
      Dir.mkdir(bin)
      %w[bash grep find].each do |cmd|
        found = ENV.fetch("PATH").split(":").map { |d| File.join(d, cmd) }.find { |f| File.executable?(f) }
        File.symlink(found, File.join(bin, cmd))
      end
      File.write(File.join(dir, "notes.txt"), "needle\n")
      original = ENV.fetch("PATH")
      ENV["PATH"] = bin
      Dir.chdir(dir) { example.run }
    ensure
      ENV["PATH"] = original
    end
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
