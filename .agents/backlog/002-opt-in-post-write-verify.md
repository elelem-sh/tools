As a `user editing files with elelem-tools loaded`, I `want verify to
run after a write only when I ask for it, and without extra prompts`,
so that `each write does not start a test run and a permission prompt
I did not request`.

# SYNOPSIS

Make post-write verify opt-in, and run its commands under verify's own
approval.

# DESCRIPTION

`verify.rb:47-49` adds an `after("write")` hook whenever elelem-tools
is loaded. After every successful write it runs the `verify` tool,
which runs a syntax check for the file type and then `bin/test` or
`script/test` if either exists (verify.rb:16-28). For a project with a
slow suite, every write now costs a full test run.

The commands run through `agent.toolbox.run("execute", ...)` directly
(verify.rb:40), not through `Tools.exec`, so they are not marked as
nested. Each one is therefore checked as a top-level `execute` call.
With the default rules (`execute: ask`, `verify: allow`) every write
can prompt twice: once for the syntax check and once for the test
runner. Approving `verify` does not cover the commands it builds,
because `verify` is allowed without a prompt and `Tools.approved` is
false (permissions.rb:26-27).

Already fixed on main: the verify result is merged into the write
result as `verify:` (verify.rb:48), so the model sees it, and a failed
check is an error (`ok: false`).

Proposed behavior:

* The post-write hook is off by default. Turn it on with a setting
  (decide the form in design: environment variable, setup option, or
  a key in an agents config file).
* The `verify` tool itself stays available for the model to call.
* Commands that verify builds run as nested calls, with the same rule
  `glob`, `grep` and `list` follow: no second prompt when a person just
  approved `verify`; still a prompt, showing the exact command, when
  `verify` was allowed without asking; `execute: deny` still wins.

# SEE ALSO

* [ ] lib/elelem/tools/verify.rb:40 - execute run as a top-level call
* [ ] lib/elelem/tools/verify.rb:47 - after("write") hook, always on
* [ ] lib/elelem/tools/exec.rb:12 - Tools.exec, the nested path
* [ ] lib/elelem/tools/permissions.rb:34 - nested approval rule
* [ ] spec/elelem/tools/verify_spec.rb
* [ ] Formerly elelem-sh/elelem.sh#3

# Tasks

* [ ] TBD (filled in design mode)

# Acceptance Criteria

* [ ] By default a write does not run verify or any test command
* [ ] With the setting on, a write runs verify and the result appears
      in the write result as today
* [ ] When `verify` is approved at a prompt, its commands do not prompt
      again
* [ ] When `verify` is allowed without a prompt, each command still
      asks and shows the exact command line
* [ ] `execute: deny` blocks verify's commands
* [ ] Specs cover the default, the opt-in, and the prompt counts
