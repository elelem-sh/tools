# frozen_string_literal: true

module Elelem
  module Tools
    # glob, grep and list run their command through execute. When a person was
    # just asked about the outer call, which shows the same arguments, the
    # command it builds does not ask again. When the outer call was allowed
    # without asking, the command still asks. A deny on execute always applies.
    # git is not one of them: repository config can make any git command run a
    # program, so git is allowed by default and execute asks for its exact
    # command line, once.
    def self.exec(toolbox, *args)
      command = args.flatten.map { |a| Shellwords.escape(a.to_s) }.join(" ")
      nested { toolbox.run("execute", { "command" => command }) }
    end

    def self.bash? = Elelem::Builtins.shell == :bash

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

    def self.approved?
      Thread.current[:elelem_tools_approved] == true
    end

    def self.approved=(value)
      Thread.current[:elelem_tools_approved] = value
    end

    # rg and grep exit 1 when nothing matches. That is an answer, not a failure.
    def self.no_matches(result)
      return result unless result[:exit_status] == 1 && result[:content].to_s.strip.empty?

      result.to_h.except(:ok, :error).merge(content: "no matches")
    end

    # bash exits 127 when the command is not installed, 126 when it cannot run
    # it. rg exits 1 when nothing matches, which is not a reason to fall back.
    def self.missing?(result)
      [126, 127].include?(result[:exit_status])
    end
  end
end
