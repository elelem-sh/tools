# frozen_string_literal: true

require "shellwords"

class Verifiers
  SYNTAX = {
    ".rb" => "ruby -c %{path}",
    ".erb" => "erb -x %{path} | ruby -c",
    ".py" => "python -m py_compile %{path}",
    ".go" => "go vet %{path}",
    ".rs" => "cargo check --quiet",
    ".ts" => "npx tsc --noEmit %{path}",
    ".js" => "node --check %{path}"
  }.freeze

  def self.for(path)
    return [] unless path

    cmds = []
    ext = File.extname(path)
    cmds << format(SYNTAX[ext], path: Shellwords.escape(path)) if SYNTAX[ext]
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
                      required: ["path"]) do |args|
      path = args["path"]
      Verifiers.for(path).each_with_object({ verified: [] }) do |cmd, memo|
        agent.output.doing("execute", { "command" => cmd })
        v = agent.toolbox.run("execute", { "command" => cmd })
        break v.to_h.merge(path: path, command: cmd) unless v.ok?

        memo[:verified] << cmd
      end
    end

    agent.toolbox.after("write") do |_, result|
      result[:verify] = agent.toolbox.run("verify", { "path" => result[:path] }).to_h unless result[:error]
    end
  end
end
