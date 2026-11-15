# frozen_string_literal: true

RSpec.describe "the verify tool" do
  around { |example| Dir.mktmpdir { |dir| Dir.chdir(dir) { example.run } } }

  it "fails when a check fails" do
    File.write("bad.rb", "def oops")
    result = run_tool("verify", { "path" => "bad.rb" })

    expect(result).not_to be_ok
    expect(result[:error]).to eq("ruby -c bad.rb exited 1")
  end

  it "passes when every check passes" do
    File.write("good.rb", "1")

    expect(run_tool("verify", { "path" => "good.rb" })[:verified]).to eq(["ruby -c good.rb"])
  end
end
