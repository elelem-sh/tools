# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:edit) do |agent|
    agent.toolbox.add("edit",
                      description: "Replace the one occurrence of old with new in a file",
                      params: { path: { type: "string" }, old: { type: "string" }, new: { type: "string" } },
                      required: %w[path old new]) do |args|
      content = Pathname.new(args["path"]).expand_path.read
      first = content.index(args["old"]) unless args["old"].empty?
      next { error: "old not found" } unless first
      # index also finds overlapping matches, and copes with invalid bytes.
      next { error: "old matches more than once; include more context" } if content.index(args["old"], first + 1)

      # The block form takes new literally, so \0 and \1 are not expanded.
      agent.toolbox
           .run("write", { "path" => args["path"], "content" => content.sub(args["old"]) { args["new"] } })
           .merge(replaced: args["old"], with: args["new"])
    end
  end
end
