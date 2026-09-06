# frozen_string_literal: true

Elelem::Plugins.register(:glob) do |agent|
  agent.toolbox.add("glob",
    description: "Find files matching pattern",
    params: { pattern: { type: "string" }, path: { type: "string" } },
    required: ["pattern"]
  ) do |args|
    path = args["path"].to_s.empty? ? "." : args["path"]
    result = agent.toolbox.exec("fd", "--glob", args["pattern"], path)
    result[:ok] ? result : agent.toolbox.exec("find", path, "-name", args["pattern"])
  end
end
