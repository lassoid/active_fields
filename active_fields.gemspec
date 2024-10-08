# frozen_string_literal: true

require_relative "lib/active_fields/version"

Gem::Specification.new do |spec|
  spec.name = "active_fields"
  spec.version = ActiveFields::VERSION
  spec.authors = ["Kirill Usanov", "LassoID"]
  spec.email = "kirill@lassoid.ru"

  spec.summary = "Add custom fields to ActiveRecord models at runtime."
  spec.description = "Extend your Rails models without changing DB schema."
  spec.homepage = "https://github.com/lassoid/active_fields"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lassoid/active_fields"
  spec.metadata["changelog_uri"] = "https://github.com/lassoid/active_fields/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    %x(git ls-files -z).split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "rails", ">= 7.0"

  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-factory_bot"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rails"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "rubocop-rspec_rails"
  spec.add_development_dependency "rubocop-shopify"
end
