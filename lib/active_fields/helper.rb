# frozen_string_literal: true

module ActiveFields
  # Mix-in that adds some useful helper methods
  module Helper
    extend ActiveSupport::Concern

    private

    # Returns the necessary filters for the `permit` method to allow all customizable active_values attributes
    #   active_fields_permitted_attributes(customizable)
    #   #=> [:single_field, :other_field, { array_field: [] }]
    def active_fields_permitted_attributes(customizable)
      customizable.active_fields.map { |field| field.array? ? { field.name => [] } : field.name }
    end
  end
end
