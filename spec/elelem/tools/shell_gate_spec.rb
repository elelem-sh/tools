# frozen_string_literal: true

RSpec.describe "tools that need bash" do
  after { Elelem::Builtins.finder = nil }

  def tool_names(windows)
    path = windows ? "" : ENV.fetch("PATH")
    Elelem::Builtins.finder = Elelem::Builtins::Shell.new(env: { "PATH" => path }, windows: windows)
    Elelem::Config.build_session("demo", input: Elelem::NullInput.new, output: Elelem::NullOutput.new)
                  .toolbox.to_a.map { |tool| tool.dig(:function, :name) }
  end

  it "are registered when execute runs in bash" do
    expect(tool_names(false)).to include("git", "glob", "grep", "list", "verify", "edit", "execute")
  end

  it "are left out when execute runs in cmd.exe" do
    names = tool_names(true)

    expect(names).not_to include("git", "glob", "grep", "list", "verify")
    expect(names).to include("edit", "execute", "read", "write")
  end
end
