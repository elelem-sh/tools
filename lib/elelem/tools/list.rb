# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:list) do |agent|
    next unless Elelem::Tools.bash?

    agent.toolbox.add("list",
                      description: "List directory contents",
                      params: { path: { type: "string" }, recursive: { type: "boolean" } },
                      required: [],
                      aliases: ["ls"]) do |args|
      path = args["path"] && !args["path"].empty? ? args["path"] : "."
      flags = args["recursive"] ? "-laR" : "-la"
      Elelem::Tools.exec(agent.toolbox, "ls", flags, "--", path)
    end
  end
end
