# frozen_string_literal: true

module Elelem
  module Tools
    def self.exec(toolbox, *args)
      command = args.flatten.map { |a| Shellwords.escape(a.to_s) }.join(" ")
      toolbox.run("execute", { "command" => command })
    end
  end
end
