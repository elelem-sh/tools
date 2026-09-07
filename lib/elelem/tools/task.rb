# frozen_string_literal: true

Elelem::Plugins.register(:task) do |agent|
  agent.toolbox.add("task",
    description: "Delegate subtask to focused agent (complex searches, multi-file analysis)",
    params: { prompt: { type: "string" } },
    required: ["prompt"]
  ) do |args|
    sub = Elelem::Tools.fork(agent, system_prompt: "Research agent. Search, analyze, report. Be concise.")
    sub.turn(args["prompt"])
    { result: sub.conversation.last[:content] }
  end
end
