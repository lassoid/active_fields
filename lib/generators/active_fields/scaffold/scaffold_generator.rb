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

      def insert_into_application_controller
        inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
          optimize_indentation(<<~CODE, 2)
            include ActiveFieldsControllerConcern
            helper ActiveFieldsHelper
          CODE
        end
      end

      def add_routes
        route "resources :active_fields"
      end
    end
  end
end
