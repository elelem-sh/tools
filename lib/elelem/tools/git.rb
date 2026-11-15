# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:git) do |agent|
    agent.toolbox.add("git",
                      description: "Run git command",
                      params: { command: { type: "string" }, args: { type: "array", items: { type: "string" } } },
                      required: ["command"]) do |args|
      result = Elelem::Tools.exec(agent.toolbox, "git", args["command"], *(args["args"] || []))
      next result if result.ok? || result[:error]

      result.to_h.merge(error: "git #{args["command"]} exited #{result[:exit_status]}")
    end

    agent.toolbox.after("git") do |_, result|
      agent.output.say "  ! #{result[:error]}" if result[:error]
    end
  end
end
