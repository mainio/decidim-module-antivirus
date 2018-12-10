# frozen_string_literal: true

require "decidim/dev/common_rake"

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app"

desc "Generates a development app."
task development_app: "decidim:generate_external_development_app"

# Run all tests, with coverage report
RSpec::Core::RakeTask.new(:coverage) do |t, task_args|
  ENV['SIMPLECOV'] = '1'
  ENV['CODECOV'] = '1'
  t.verbose = false
end

# Run all tests, include all
RSpec::Core::RakeTask.new(:spec) do |t, task_args|
  t.verbose = false
end

# Run both by default
task default: [:test_app, :spec, :coverage]
