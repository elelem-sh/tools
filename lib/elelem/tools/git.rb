# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:git) do |agent|
    agent.toolbox.add("git",
                      description: "Run git command",
                      params: { command: { type: "string" }, args: { type: "array", items: { type: "string" } } },
                      required: ["command"]) do |args|
      refused = Elelem::Tools.unsafe_git(args["command"], args["args"] || [])
      next { error: "git #{refused} can run other programs; use execute so the command is shown" } if refused

      result = Elelem::Tools.exec(agent.toolbox, "git", args["command"], *(args["args"] || []))
      next result if result.ok? || result[:error]

      result.to_h.merge(error: "git #{args["command"]} exited #{result[:exit_status]}")
    end

    agent.toolbox.after("git") do |_, result|
      agent.output.say "  ! #{result[:error]}" if result[:error]
    end
  end
end
