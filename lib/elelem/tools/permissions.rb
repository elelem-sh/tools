# frozen_string_literal: true

module Elelem
  module Tools
    class Permissions
      LOAD_PATHS = [
        File.expand_path("permissions.json", __dir__),
        "~/.agents/permissions.json",
        ".agents/permissions.json"
      ].freeze

      def initialize(rules: default_rules)
        @rules = rules
      end

      def check(tool_name, args, input:)
        policy = @rules[tool_name.to_sym] || :ask
        case policy
        when :allow then true
        when :deny then raise "Permission denied: #{tool_name}"
        else prompt(tool_name, args, input)
        end
      end

      private

      def load_config(path)
        return {} unless File.exist?(path)

        data = JSON.parse(File.read(path))
        return {} unless data.is_a?(Hash)

        data.transform_keys(&:to_sym).transform_values { |v| v.to_s.to_sym }
      rescue JSON::ParserError
        {}
      end

      def prompt(tool_name, _args, input)
        return true unless input.interactive?

        answer = input.ask("  Allow? [Y/n] > ")&.downcase
        raise "User denied permission: #{tool_name}" if answer == "n"

        true
      end

      def default_rules
        LOAD_PATHS.reduce({}) do |rules, path|
          rules.merge(load_config(File.expand_path(path)))
        end
      end
    end
  end
end
