# frozen_string_literal: true

Elelem::Plugins.register(:verify) do |agent|
  agent.toolbox.add("verify",
    description: "Verify file syntax and run tests",
    params: { path: { type: "string" } },
    required: ["path"]
  ) do |args|
    path = args["path"]
    Elelem::Plugins::Verifiers.for(path).inject({ verified: [] }) do |memo, cmd|
      agent.terminal.say agent.toolbox.header("execute", { "command" => cmd })
      v = agent.toolbox.run("execute", { "command" => cmd })
      break v.merge(path: path, command: cmd) if v[:exit_status] != 0

      memo[:verified] << cmd
      memo
    end
  end
end
