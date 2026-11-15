# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:edit) do |agent|
    agent.toolbox.add("edit",
                      description: "Replace the one occurrence of old with new in a file",
                      params: { path: { type: "string" }, old: { type: "string" }, new: { type: "string" } },
                      required: %w[path old new]) do |args|
      content = Pathname.new(args["path"]).expand_path.read
      count = args["old"].empty? ? 0 : content.scan(args["old"]).size
      next { error: count.zero? ? "old not found" : "old matches #{count} times; include more context" } if count != 1

      # The block form takes new literally, so \0 and \1 are not expanded.
      agent.toolbox
           .run("write", { "path" => args["path"], "content" => content.sub(args["old"]) { args["new"] } })
           .merge(replaced: args["old"], with: args["new"])
    end
  end
end
