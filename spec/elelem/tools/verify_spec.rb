# frozen_string_literal: true

RSpec.describe "the verify tool" do
  around { |example| Dir.mktmpdir { |dir| Dir.chdir(dir) { example.run } } }

  it "fails when a check fails" do
    File.write("bad.rb", "def oops")
    result = run_tool("verify", { "path" => "bad.rb" })

    expect(result).not_to be_ok
    expect(result[:error]).to include(result[:exit_status].to_s)
  end

  it "checks a written file once, in the write's own result" do
    checks = []
    session.toolbox.before("execute") { |args| checks << args["command"] }
    result = run_tool("write", { "path" => "bad.rb", "content" => "def oops" })

    expect(result[:verify]).to include(command: "ruby -c bad.rb", ok: false)
    expect(checks).to eq(["ruby -c bad.rb"])
  end

  it "passes when every check passes" do
    File.write("good.rb", "1")

    expect(run_tool("verify", { "path" => "good.rb" })[:verified]).to eq(["ruby -c good.rb"])
  end

  it "passes the path to the shell as one word" do
    path = "a b; touch pwned.rb"
    File.write(path, "1")

    expect(run_tool("verify", { "path" => path })).to be_ok
    expect(File).not_to exist("pwned.rb")
  end
end
