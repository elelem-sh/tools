# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:glob) do |agent|
    next unless Elelem::Tools.bash?

    agent.toolbox.add("glob",
                      description: "Find files matching pattern",
                      params: { pattern: { type: "string" }, path: { type: "string" } },
                      required: ["pattern"]) do |args|
      path = args["path"].to_s.empty? ? "." : args["path"]
      # find has no --, so a path like -delete becomes ./-delete.
      path = "./#{path}" if path.start_with?("-")
      result = Elelem::Tools.exec(agent.toolbox, "fd", "--glob", "--", args["pattern"], path)
      next result unless Elelem::Tools.missing?(result)

      Elelem::Tools.exec(agent.toolbox, "find", path, "-name", args["pattern"])
    end
  end
end
