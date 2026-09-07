# frozen_string_literal: true

class Verifiers
  SYNTAX = {
    ".rb" => "ruby -c %{path}",
    ".erb" => "erb -x %{path} | ruby -c",
    ".py" => "python -m py_compile %{path}",
    ".go" => "go vet %{path}",
    ".rs" => "cargo check --quiet",
    ".ts" => "npx tsc --noEmit %{path}",
    ".js" => "node --check %{path}",
  }.freeze

  def self.for(path)
    return [] unless path

    cmds = []
    ext = File.extname(path)
    cmds << (SYNTAX[ext] % { path: path }) if SYNTAX[ext]
    cmds << test_runner
    cmds.compact
  end

  def self.test_runner
    %w[bin/test script/test].find { |s| File.executable?(s) }
  end
end

Elelem.configure do |config|
  config.setup(:verify) do |agent|
    agent.toolbox.add("verify",
      description: "Verify file syntax and run tests",
      params: { path: { type: "string" } },
      required: ["path"]
    ) do |args|
      path = args["path"]
      Verifiers.for(path).inject({ verified: [] }) do |memo, cmd|
        agent.output.doing("execute", { "command" => cmd })
        v = agent.toolbox.run("execute", { "command" => cmd })
        break v.merge(path: path, command: cmd) if v[:exit_status] != 0

        memo[:verified] << cmd
        memo
      end
    end
  end
end
