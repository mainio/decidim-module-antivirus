# frozen_string_literal: true

require "decidim/dev"

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path =
  File.expand_path(File.join(__dir__, "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"

RSpec.configure do |config|
  config.before do
    # Make sure no addons are applied for the sake of not interfering with the
    # default tests.
    Ratonvirus.configure do |rv_config|
      rv_config.addons = []
    end
  end
end
