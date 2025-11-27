# frozen_string_literal: true

p ENV["BUNDLE_GEMFILE"]
p __dir__
p File.expand_path("../../..", __dir__)

# Convert relative path to absolute, using project root as base
ENV["BUNDLE_GEMFILE"] = File.expand_path(
  ENV["BUNDLE_GEMFILE"] || "Gemfile",
  File.expand_path("../../..", __dir__),
)

p ENV["BUNDLE_GEMFILE"]

# Set up gems listed in the Gemfile.
require "bundler/setup" if File.exist?(ENV["BUNDLE_GEMFILE"])

$LOAD_PATH.unshift File.expand_path("../../../lib", __dir__)
