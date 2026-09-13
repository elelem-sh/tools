# frozen_string_literal: true

module Elelem
  module Tools
    def self.fork(agent, template:)
      Elelem::Agent.new(agent.provider, toolbox: agent.toolbox, output: agent.output, template: template)
    end
  end
end
