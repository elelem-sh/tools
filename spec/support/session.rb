# frozen_string_literal: true

module SessionHelper
  def session
    @session ||= Elelem::Config.build_session("demo", input: Elelem::NullInput.new, output: Elelem::NullOutput.new)
  end

  def run_tool(name, args)
    session.toolbox.run(name, args)
  end
end
