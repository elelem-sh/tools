# frozen_string_literal: true

# A pattern or path the model chooses must never become an option that runs
# a program or deletes files.
RSpec.describe "tool arguments that look like options" do
  around { |example| Dir.mktmpdir { |dir| Dir.chdir(dir) { example.run } } }

  before do
    File.write("notes.txt", "hello\n")
    File.write("x.sh", "#!/bin/sh\ntouch pwned\n")
    File.chmod(0o755, "x.sh")
  end

  it "grep searches for a pattern like --pre=CMD instead of running CMD" do
    run_tool("grep", { "pattern" => "--pre=./x.sh" })

    expect(File).not_to exist("pwned")
  end

  it "grep finds a pattern that starts with -" do
    File.write("flags.txt", "-v\n")

    expect(run_tool("grep", { "pattern" => "-v" })[:content]).to include("flags.txt")
  end

  it "glob does not take a path like -delete as an action" do
    run_tool("glob", { "pattern" => "zzz", "path" => "-delete" })

    expect(File).to exist("notes.txt")
  end

  it "list takes a path like -R as a name" do
    expect(run_tool("list", { "path" => "-R" })).not_to be_ok
  end

  it "git refuses options that run another program" do
    [{ "command" => "-c", "args" => ["alias.x=!touch pwned", "x"] },
     { "command" => "fetch", "args" => ["--upload-pack=touch pwned", "origin"] },
     { "command" => "diff", "args" => ["--ext-diff"] }].each do |call|
      expect(run_tool("git", call)[:error]).to match(/can run other programs/)
    end
    expect(File).not_to exist("pwned")
  end

  it "git still runs ordinary commands" do
    system("git", "init", "-q", ".")

    expect(run_tool("git", { "command" => "status", "args" => ["--short"] })).to be_ok
  end
end
