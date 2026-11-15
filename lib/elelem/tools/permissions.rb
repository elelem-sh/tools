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

      def prompt(tool_name, args, input)
        return true unless input.interactive?

        answer = input.ask("  Allow #{tool_name}#{subject(tool_name, args)}? [Y/n] > ")
        # nil is end of input (Ctrl+D), which refuses. An empty line accepts.
        raise "User denied permission: #{tool_name}" if answer.nil? || answer.downcase == "n"

        true
      end

      # The whole command, never cut, so nothing hidden gets approved.
      def subject(tool_name, args)
        return "" if args.nil? || args.empty?

        command = args["command"] if tool_name.to_s == "execute"
        text = command ? command.to_s : JSON.generate(args)
        # Control and format characters (\r, ESC, bidi overrides) could redraw the prompt.
        " `#{text.match?(/[\p{Cc}\p{Cf}]/) ? text.dump : text}`"
      end

      def default_rules
        LOAD_PATHS.reduce({}) do |rules, path|
          rules.merge(load_config(File.expand_path(path)))
        end
      end
    end
  end
end
