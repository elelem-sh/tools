# frozen_string_literal: true

require_relative "../lib/elelem/tools"
require_relative "support/session"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.include SessionHelper

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
