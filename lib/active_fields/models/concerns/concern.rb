# frozen_string_literal: true

# Mix-in that provides ActiveRecord models with active fields functionality
module ActiveFields
  module Concern
    extend ActiveSupport::Concern

    class_methods do
      def has_active_fields(options = {})
        include ActiveFields::Customizable

        @__active_fields_options__ = options.dup
      end
    end
  end
end
