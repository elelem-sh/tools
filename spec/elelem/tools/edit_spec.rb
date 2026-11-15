# frozen_string_literal: true

RSpec.describe "the edit tool" do
  around { |example| Dir.mktmpdir { |dir| Dir.chdir(dir) { example.run } } }

  before { File.write("a.txt", "one two two") }

  it "replaces the one occurrence" do
    expect(run_tool("edit", { "path" => "a.txt", "old" => "one", "new" => "1" })).to be_ok
    expect(File.read("a.txt")).to eq("1 two two")
  end

  it "fails when old is missing" do
    expect(run_tool("edit", { "path" => "a.txt", "old" => "three", "new" => "3" })[:error]).to eq("old not found")
    expect(File.read("a.txt")).to eq("one two two")
  end

  it "fails when old matches more than once" do
    expect(run_tool("edit", { "path" => "a.txt", "old" => "two", "new" => "2" })[:error]).to match(/more than once/)
  end

  it "counts overlapping matches" do
    File.write("a.txt", "aaa")

    expect(run_tool("edit", { "path" => "a.txt", "old" => "aa", "new" => "b" })[:error]).to match(/more than once/)
  end

  it "edits a file with bytes that are not UTF-8" do
    File.binwrite("a.txt", "caf\xE9 one")
    run_tool("edit", { "path" => "a.txt", "old" => "one", "new" => "1" })

    expect(File.binread("a.txt")).to eq("caf\xE9 1".b)
  end

  it "takes new literally" do
    run_tool("edit", { "path" => "a.txt", "old" => "one", "new" => "\\0 \\1" })

    expect(File.read("a.txt")).to eq("\\0 \\1 two two")
  end
end
