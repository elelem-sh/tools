# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:grep) do |agent|
    agent.toolbox.add("grep",
                      description: "Search file contents",
                      params: { pattern: { type: "string" }, path: { type: "string" }, glob: { type: "string" } },
                      required: ["pattern"]) do |args|
      path = args["path"].to_s.empty? ? "." : args["path"]
      glob = args["glob"]

      rg_args = ["rg", "-n", args["pattern"], path]
      rg_args += ["-g", glob] if glob
      result = Elelem::Tools.exec(agent.toolbox, *rg_args)
      if Elelem::Tools.missing?(result)
        grep_args = ["grep", "-rn"]
        grep_args += ["--include", glob] if glob
        grep_args += [args["pattern"], path]
        result = Elelem::Tools.exec(agent.toolbox, *grep_args)
      end
      Elelem::Tools.no_matches(result)
    end
  end
end
