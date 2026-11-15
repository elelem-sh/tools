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
end
