# frozen_string_literal: true

module Elelem
  module Tools
    def self.fork(agent, system_prompt:)
      Elelem::Agent.new(agent.provider, toolbox: agent.toolbox, output: agent.output, input: agent.input, system_prompt: system_prompt)
    end
  end
end
