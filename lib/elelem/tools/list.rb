# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:list) do |agent|
    agent.toolbox.add("list",
      description: "List directory contents",
      params: { path: { type: "string" }, recursive: { type: "boolean" } },
      required: [],
      aliases: ["ls"]
    ) do |args|
      path = args["path"] && !args["path"].empty? ? args["path"] : "."
      flags = args["recursive"] ? "-laR" : "-la"
      agent.toolbox.exec("ls", flags, path)
    end
  end
end
