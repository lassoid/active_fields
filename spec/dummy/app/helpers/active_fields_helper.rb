# frozen_string_literal: true

module ActiveFieldsHelper
  def active_fields_new_form(active_field)
    type = ActiveFields.config.fields.key(active_field.type) # TODO: maybe add model method?

    "active_fields/new_forms/#{type}"
  end
end
