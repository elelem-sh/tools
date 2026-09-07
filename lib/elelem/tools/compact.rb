# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:compact) do |agent|
    agent.commands.register("compact", description: "Compress context") do
      response = agent.turn("Summarize: accomplishments, state, next steps. Brief.")
      agent.conversation.clear!
      agent.conversation.add(role: "user", content: "Context: #{response}")
      agent.terminal.say "  → compacted"
    end
  end
end
