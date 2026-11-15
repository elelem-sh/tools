# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:git) do |agent|
    agent.toolbox.add("git",
                      description: "Run git command",
                      params: { command: { type: "string" }, args: { type: "array", items: { type: "string" } } },
                      required: ["command"]) do |args|
      command = args["command"].to_s
      rest = args["args"] || []
      result =
        if Elelem::Tools.git_read_only?(command, rest)
          Elelem::Tools.exec(agent.toolbox, "git", *Elelem::Tools::GIT_SAFE_CONFIG, command, *rest)
        else
          # Asks for the exact command line, whatever the git call's policy.
          line = ["git", command, *rest].map { |a| Shellwords.escape(a.to_s) }.join(" ")
          agent.toolbox.run("execute", { "command" => line })
        end
      next result if result.ok? || result[:error]

      result.to_h.merge(error: "git #{args["command"]} exited #{result[:exit_status]}")
    end

    agent.toolbox.after("git") do |_, result|
      agent.output.say "  ! #{result[:error]}" if result[:error]
    end
  end
end
