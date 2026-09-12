# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:glob) do |agent|
    agent.toolbox.add("glob",
                      description: "Find files matching pattern",
                      params: { pattern: { type: "string" }, path: { type: "string" } },
                      required: ["pattern"]) do |args|
      path = args["path"].to_s.empty? ? "." : args["path"]
      result = Elelem::Tools.exec(agent.toolbox, "fd", "--glob", args["pattern"], path)
      result[:ok] ? result : Elelem::Tools.exec(agent.toolbox, "find", path, "-name", args["pattern"])
    end
  end
end
