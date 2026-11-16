As a `user running elelem without a terminal`, I `want tools set to
ask to be refused unless I opted in`, so that `a piped or CI run cannot
run commands nobody approved`.

# SYNOPSIS

Refuse `ask` tools when input is not interactive, and warn on unknown
policies.

# DESCRIPTION

`Permissions#prompt` returns true as soon as the input is not
interactive (permissions.rb:50). Every `elelem ask` run, every pipe and
every CI job therefore runs `execute` and any other tool whose policy
is `ask` without asking anyone. Only `deny` blocks. The default
permissions.json sets `execute` to `ask`, so by default a
non-interactive run executes any shell command the model chooses.

A policy value that is not `allow`, `deny` or `ask` (a typo in
permissions.json, such as `dney`) is now treated like `ask`
(permissions.rb:20-29). That is safe at a terminal, but it is silent:
no warning names the bad value, and without a terminal it allows the
call, like any other `ask`.

Already fixed on main and not part of this story:

* Only Enter, `y` or `yes` approve; anything else, including end of
  input, refuses (permissions.rb:13, :53).
* The prompt shows the arguments, and the full command for `execute`,
  with control characters escaped (permissions.rb:58-66).
* Commands built by an approved tool do not prompt a second time
  (permissions.rb:34-36, exec.rb).

Proposed behavior:

* Without a terminal, `ask` refuses with a message that says which
  tool was refused and how to allow it.
* An explicit opt-in allows `ask` tools without a terminal, for people
  who run elelem in a sandbox on purpose. Choose its form in design
  (an environment variable, a CLI flag, or an `allow` rule in
  permissions.json, which already works today).
* An unknown policy logs a warning naming the tool, the value and the
  file, and is then treated as `ask` (or `deny`; decide in design).

This changes default behavior for scripted users, so it needs a
changelog note.

# SEE ALSO

* [ ] lib/elelem/tools/permissions.rb:20 - unknown policy becomes ask
* [ ] lib/elelem/tools/permissions.rb:50 - non-interactive ask allows
* [ ] lib/elelem/tools/permissions.json - execute defaults to ask
* [ ] spec/elelem/tools/permissions_spec.rb:26 - spec that pins the
      current non-interactive behavior
* [ ] Formerly elelem-sh/elelem.sh#2

# Tasks

* [ ] TBD (filled in design mode)

# Acceptance Criteria

* [ ] With non-interactive input and no opt-in, a tool with policy
      `ask` raises a permission error and does not run
* [ ] The error names the tool and says how to allow it
* [ ] With the opt-in, a non-interactive `ask` tool runs
* [ ] `allow` and `deny` behave as before, with or without a terminal
* [ ] An unknown policy logs a warning naming the tool and the value
* [ ] Specs cover each case above
* [ ] The changelog notes the change for scripted users
