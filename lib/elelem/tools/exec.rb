# frozen_string_literal: true

module Elelem
  module Tools
    # git, glob, grep and list run their command through execute. The person
    # approved the outer call, which shows the same arguments, so asking again
    # for the command it builds adds a prompt and nothing else. A deny on
    # execute still applies.
    def self.exec(toolbox, *args)
      command = args.flatten.map { |a| Shellwords.escape(a.to_s) }.join(" ")
      nested { toolbox.run("execute", { "command" => command }) }
    end

    def self.nested
      outer = Thread.current[:elelem_tools_nested]
      Thread.current[:elelem_tools_nested] = true
      yield
    ensure
      Thread.current[:elelem_tools_nested] = outer
    end

    def self.nested?
      Thread.current[:elelem_tools_nested] == true
    end

    # bash exits 127 when the command is not installed, 126 when it cannot run
    # it. rg exits 1 when nothing matches, which is not a reason to fall back.
    def self.missing?(result)
      [126, 127].include?(result[:exit_status])
    end
  end
end
