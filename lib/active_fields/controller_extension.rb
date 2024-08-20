# frozen_string_literal: true

module ActiveFields
  # Controller mix-in that adds some useful helper methods
  module ControllerExtension
    extend ActiveSupport::Concern

    private

    def active_fields_permitted_attributes(record)
      record.active_fields.map { |field| field.array? ? { field.name => [] } : field.name }
    end
  end
end
