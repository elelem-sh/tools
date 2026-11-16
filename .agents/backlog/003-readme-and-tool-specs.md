As a `person deciding whether to install elelem-tools`, I `want a
README and a spec for each tool`, so that `I know what each tool does,
how to turn it on, and that it keeps working`.

# SYNOPSIS

Add a README and specs for the tools that have none.

# DESCRIPTION

The repository has no README. A visitor to the GitHub page or the gem
sees no description of the tools, the permission rules, or how to load
the plugin.

The README should cover, briefly:

* Install, and the loader file elelem needs to load a gem plugin
  (`~/.agents/plugins/tools.rb` containing `require "elelem/tools"`),
  until core loads installed plugins on its own.
* The tools and commands it adds: compact, edit, eval, fork, git,
  glob, grep, init, interview, list, shell, task, verify, and the
  permission prompt (confirm).
* Permissions: the three policies, the load order of permissions.json
  (gem default, `~/.agents/permissions.json`,
  `.agents/permissions.json`) and the defaults.
* A link to https://elelem.sh/plugins/tools/ for the full guide.

The elelem.sh plugin page can be the source for the text.

Specs: when the issue was filed only permissions had specs. Main now
also has specs for edit, git, verify, the grep and glob fallbacks, and
option-like arguments (spec/elelem/tools/). Still without specs: list,
eval, task, interview, compact, fork, init and shell, and grep and glob
beyond their fallbacks.

# SEE ALSO

* [ ] lib/elelem/tools.rb - list of tool files
* [ ] lib/elelem/tools/permissions.rb:6 - permissions load paths
* [ ] lib/elelem/tools/permissions.json - default policies
* [ ] spec/elelem/tools/ - existing specs
* [ ] https://elelem.sh/plugins/tools/ - source for README text
* [ ] Formerly elelem-sh/elelem.sh#23

# Tasks

* [ ] TBD (filled in design mode)

# Acceptance Criteria

* [ ] README.md exists and covers install, loading, each tool, and
      permissions
* [ ] README commands have no leading `$`, so they can be pasted
* [ ] Each tool registered by the gem has at least one spec of its
      main behavior
* [ ] bin/test passes
