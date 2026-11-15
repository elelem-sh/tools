# frozen_string_literal: true

module Elelem
  module Tools
    def self.exec(toolbox, *args)
      command = args.flatten.map { |a| Shellwords.escape(a.to_s) }.join(" ")
      toolbox.run("execute", { "command" => command })
    end

    # bash exits 127 when the command is not installed. rg exits 1 when
    # nothing matches, so a non-zero status alone is not a reason to fall back.
    def self.missing?(result)
      result[:exit_status] == 127
    end
  end
end
