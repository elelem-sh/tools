# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:grep) do |agent|
    agent.toolbox.add("grep",
      description: "Search file contents",
      params: { pattern: { type: "string" }, path: { type: "string" }, glob: { type: "string" } },
      required: ["pattern"]
    ) do |args|
      path = args["path"].to_s.empty? ? "." : args["path"]
      glob = args["glob"]

      rg_args = ["rg", "-n", args["pattern"], path]
      rg_args += ["-g", glob] if glob
      result = Elelem::Tools.exec(agent.toolbox, *rg_args)
      next result if result[:ok]

      grep_args = ["grep", "-rn"]
      grep_args += ["--include", glob] if glob
      grep_args += [args["pattern"], path]
      Elelem::Tools.exec(agent.toolbox, *grep_args)
    end
  end
end
