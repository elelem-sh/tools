# frozen_string_literal: true

RSpec.describe "the git tool" do
  around { |example| Dir.mktmpdir { |dir| Dir.chdir(dir) { example.run } } }

  it "reports a failing git command as an error" do
    result = run_tool("git", { "command" => "log" })

    expect(result).not_to be_ok
    expect(result[:error]).to match(/\Agit log exited \d+\z/)
  end

  it "passes a working git command through" do
    system("git", "init", "-q", ".")

    expect(run_tool("git", { "command" => "status" })).to be_ok
  end

  it "asks once, showing the command line it runs" do
    home = Dir.home
    ENV["HOME"] = Dir.pwd # ignore ~/.agents/permissions.json
    system("git", "init", "-q", ".")
    prompts = []
    input = Class.new do
      define_method(:interactive?) { true }
      define_method(:ask) { |text| prompts << text and "y" }
    end.new
    session = Elelem::Config.build_session("stub", input: input, output: Elelem::NullOutput.new)

    expect(session.toolbox.run("git", { "command" => "status" })).to be_ok
    expect(prompts).to eq(["  Allow execute `git status`? [Y/n] > "])
  ensure
    ENV["HOME"] = home
  end
end
