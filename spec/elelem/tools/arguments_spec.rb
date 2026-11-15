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

  describe "git" do
    it "treats only read-only commands without unsafe options as read-only" do
      expect(Elelem::Tools.git_read_only?("status", ["--short"])).to be true
      expect(Elelem::Tools.git_read_only?("log", ["-c", "--oneline"])).to be true
      expect(Elelem::Tools.git_read_only?("diff", ["--ext-dif"])).to be false
      expect(Elelem::Tools.git_read_only?("log", ["--outp=x"])).to be false
      expect(Elelem::Tools.git_read_only?("show", ["-Ovim"])).to be false
      %w[-c config rebase filter-branch submodule bisect difftool fetch clone add commit].each do |command|
        expect(Elelem::Tools.git_read_only?(command, [])).to be false
      end
    end

    def executes_for(call)
      seen = []
      session.toolbox.before("execute") do |a|
        seen << [a["command"], Elelem::Tools.nested?]
        raise "stopped"
      end
      run_tool("git", call)
      seen
    end

    it "runs anything else through execute's own prompt, even when git is approved" do
      seen = executes_for({ "command" => "rebase", "args" => ["-xtouch pwned", "HEAD~1"] })

      expect(seen).to eq([["git rebase -xtouch\\ pwned HEAD\\~1", false]])
    end

    it "runs a read-only command under the git approval, with program settings cleared" do
      seen = executes_for({ "command" => "status", "args" => ["--short"] })

      expect(seen.first.last).to be true
      expect(seen.first.first).to start_with("git -c core.fsmonitor\\= -c core.hooksPath\\=/dev/null")
    end

    it "does not run a program set in .git/config for a read-only command" do
      system("git", "init", "-q", ".")
      system("git", "config", "core.fsmonitor", "touch pwned")

      run_tool("git", { "command" => "status" })

      expect(File).not_to exist("pwned")
    end
  end

  it "git still runs ordinary commands" do
    system("git", "init", "-q", ".")

    expect(run_tool("git", { "command" => "status", "args" => ["--short"] })).to be_ok
  end
end
