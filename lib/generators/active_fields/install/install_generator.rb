# frozen_string_literal: true

require "rails/generators"

module ActiveFields
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include ::Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      desc "This generator creates a migration to create ActiveFields tables"

      def copy_migration
        migration_template(
          "create_active_fields_tables.rb.tt",
          "db/migrate/create_active_fields_tables.rb",
          { migration_version: migration_version },
        )
      end

      private

      def migration_version
        format(
          "[%d.%d]",
          ActiveRecord::VERSION::MAJOR,
          ActiveRecord::VERSION::MINOR
        )
      end
    end
  end
end
