# frozen_string_literal: true

require "decidim/dev"

require 'simplecov'
if ENV['CODECOV']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path =
  File.expand_path(File.join(__dir__, "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"

RSpec.configure do |config|
  config.before(:each) do
    # Make sure no addons are applied for the sake of not interfering with the
    # default tests.
    Ratonvirus.configure do |config|
      config.addons = []
    end
  end
end
