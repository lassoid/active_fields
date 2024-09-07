# frozen_string_literal: true

require "rails/generators"

module ActiveFields
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "This generator creates an create_initializer and copies plugin migrations"

      def create_initializer
        initializer "active_fields.rb", <<~RUBY
          ActiveFields.configure do |config|
            # Change fields base class:
            # config.field_base_class_name = "CustomField"
            # Change value class:
            # config.value_class_name = "CustomValue"

            # Register custom field type:
            # config.register_field :ip, "IpField"
          end
        RUBY
      end

      def install_migrations
        rails_command "active_fields:install:migrations"
      end
    end
  end
end
