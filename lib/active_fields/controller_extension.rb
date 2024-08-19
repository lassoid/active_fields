# frozen_string_literal: true

module ActiveFields
  # TODO: desc
  module ControllerExtension
    extend ActiveSupport::Concern

    private

    def active_fields_permitted_attributes(record)
      record.active_fields.map { |field| field.array? ? { field.name => [] } : field.name }
    end
  end
end
