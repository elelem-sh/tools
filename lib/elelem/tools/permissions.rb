# frozen_string_literal: true

module Elelem
  module Tools
    class Permissions
      LOAD_PATHS = [
        File.expand_path("permissions.json", __dir__),
        "~/.agents/permissions.json",
        ".agents/permissions.json"
      ].freeze

      # Enter, y or yes. Anything else refuses: no, a typo, or end of input (Ctrl+D, nil).
      YES = ["", "y", "yes"].freeze

      def initialize(rules: default_rules)
        @rules = rules
      end

      def check(tool_name, args, input:)
        policy = @rules[tool_name.to_sym] || :ask
        raise "Permission denied: #{tool_name}" if policy == :deny
        return nested(tool_name, args, input, policy) if Tools.nested?

        # Remember whether a person just saw and approved this call. Only then
        # may the command it builds skip its own prompt.
        Tools.approved = false
        return true if policy == :allow

        prompt(tool_name, args, input).tap { Tools.approved = input.interactive? }
      end

      private

      def nested(tool_name, args, input, policy)
        policy == :allow || Tools.approved? || prompt(tool_name, args, input)
      end

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
        raise "User denied permission: #{tool_name}" unless YES.include?(answer&.strip&.downcase)

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
