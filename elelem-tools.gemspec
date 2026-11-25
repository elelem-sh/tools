# frozen_string_literal: true

require_relative "lib/elelem/tools/version"

Gem::Specification.new do |spec|
  spec.name = "elelem-tools"
  spec.version = Elelem::Tools::VERSION
  spec.authors = ["mo khan"]
  spec.email = ["mo@mokhan.ca"]

  spec.summary = "More tools for elelem. Permission prompts."
  spec.description = "Adds search, edit, git, sub-agent and verification tools, slash commands, " \
                     "and a hook that asks before a tool runs."
  spec.homepage = "https://elelem.sh"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 4.0.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/elelem-sh/tools"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["LICENSE.txt", "lib/**/*.rb", "lib/elelem/tools/permissions.json"]
  spec.require_paths = ["lib"]

  spec.add_dependency "elelem", ">= 0.14.4", "< 1"
  spec.add_dependency "json", ">= 2.18"
  spec.add_dependency "tempfile", "~> 0.3"
end
