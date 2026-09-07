# frozen_string_literal: true

module Elelem
  module Tools
    def self.fork(agent, system_prompt:)
      Elelem::Agent.new(agent.client, toolbox: agent.toolbox, terminal: agent.terminal, system_prompt: system_prompt)
    end
  end
end
