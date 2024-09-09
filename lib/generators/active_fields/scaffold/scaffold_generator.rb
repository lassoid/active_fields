# frozen_string_literal: true

require "rails/generators"

module ActiveFields
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "This generator creates some useful templates"

      def copy_files
        Dir.glob("**/*", base: self.class.source_root).each do |path|
          next unless File.file?(File.expand_path(path, self.class.source_root))

          copy_file path, File.join("app", path)
        end
      end

      def add_routes
        route "resources :active_fields"
      end
    end
  end
end
