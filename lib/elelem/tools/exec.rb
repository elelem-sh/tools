# frozen_string_literal: true

module Elelem
  module Tools
    # git, glob, grep and list run their command through execute. When a person
    # was just asked about the outer call, which shows the same arguments, the
    # command it builds does not ask again. When the outer call was allowed
    # without asking, the command still asks. A deny on execute always applies.
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

    def self.approved?
      Thread.current[:elelem_tools_approved] == true
    end

    def self.approved=(value)
      Thread.current[:elelem_tools_approved] = value
    end

    # git commands that only read. Only these skip their own prompt after the
    # git call was approved, because any other git command can run a program
    # (aliases, hooks, filters, --exec and the like) in ways a person reading
    # `Allow git {...}` would not expect.
    GIT_READ_ONLY = %w[status log diff show branch rev-parse ls-files blame shortlog describe tag].freeze
    # Read-only commands still take options that write files or run a program.
    # git accepts any unique prefix of a long option, so match prefixes.
    GIT_UNSAFE_LONG = %w[--output --ext-diff --textconv --open-files-in-pager].freeze
    GIT_UNSAFE_SHORT = %w[-O].freeze
    # Settings in .git/config that run programs, cleared for read-only calls.
    GIT_SAFE_CONFIG = ["-c", "core.fsmonitor=", "-c", "core.hooksPath=/dev/null", "-c", "diff.external=",
                       "-c", "core.pager=cat"].freeze

    def self.git_read_only?(command, args)
      GIT_READ_ONLY.include?(command) && args.map(&:to_s).none? { |arg| unsafe_git_arg?(arg) }
    end

    def self.unsafe_git_arg?(arg)
      return true if GIT_UNSAFE_SHORT.any? { |opt| arg.start_with?(opt) }

      name = arg.split("=", 2).first
      name.start_with?("--") && name.length > 2 && GIT_UNSAFE_LONG.any? { |opt| opt.start_with?(name) }
    end

    # rg and grep exit 1 when nothing matches. That is an answer, not a failure.
    def self.no_matches(result)
      return result unless result[:exit_status] == 1 && result[:content].to_s.strip.empty?

      result.to_h.except(:ok).merge(content: "no matches")
    end

    # bash exits 127 when the command is not installed, 126 when it cannot run
    # it. rg exits 1 when nothing matches, which is not a reason to fall back.
    def self.missing?(result)
      [126, 127].include?(result[:exit_status])
    end
  end
end
