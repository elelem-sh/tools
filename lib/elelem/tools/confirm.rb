# frozen_string_literal: true

Elelem.configure do |config|
  config.setup(:confirm) do |agent|
    permissions = Elelem::Tools::Permissions.new

    agent.toolbox.before do |args, tool_name:|
      permissions.check(tool_name, args, terminal: agent.terminal)
    end
  end
end
