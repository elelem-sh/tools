# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:edit) do |agent|
    agent.toolbox.add("edit",
                      description: "Replace first occurrence of text in file",
                      params: { path: { type: "string" }, old: { type: "string" }, new: { type: "string" } },
                      required: %w[path old new]) do |args|
      path = Pathname.new(args["path"]).expand_path
      content = path.read
      agent.toolbox
           .run("write", { "path" => args["path"], "content" => content.sub(args["old"], args["new"]) })
           .merge(replaced: args["old"], with: args["new"])
    end
  end
end
