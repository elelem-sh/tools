# frozen_string_literal: true

module Elelem
  module Tools
    def self.exec(toolbox, *args)
      command = args.flatten.map { |a| Shellwords.escape(a.to_s) }.join(" ")
      toolbox.run("execute", { "command" => command })
    end

    # bash exits 127 when the command is not installed, 126 when it cannot run
    # it. rg exits 1 when nothing matches, which is not a reason to fall back.
    def self.missing?(result)
      [126, 127].include?(result[:exit_status])
    end
  end
end
