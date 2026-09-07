# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:interview) do |agent|
    agent.toolbox.add("interview",
      description: "Ask the user a question and wait for their response",
      params: {
        question: { type: "string", description: "The question to ask the user" },
      },
      required: ["question"]
    ) do |args|
      agent.terminal.say(agent.terminal.markdown(args["question"]))
      { answer: agent.terminal.ask("> ") }
    end
  end
end
