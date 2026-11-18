# frozen_string_literal: true

RSpec.describe "tools that need bash" do
  def tool_names(shell)
    allow(Elelem::Builtins).to receive(:shell).and_return(shell)
    Elelem::Config.build_session("demo", input: Elelem::NullInput.new, output: Elelem::NullOutput.new)
                  .toolbox.to_a.map { |tool| tool.dig(:function, :name) }
  end

  it "are registered when execute runs in bash" do
    expect(tool_names(:bash)).to include("git", "glob", "grep", "list", "verify", "edit", "execute")
  end

  it "are left out when execute runs in cmd.exe" do
    names = tool_names(:cmd)

    expect(names).not_to include("git", "glob", "grep", "list", "verify")
    expect(names).to include("edit", "execute", "read", "write")
  end
end
