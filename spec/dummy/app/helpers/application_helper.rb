# frozen_string_literal: true

module ApplicationHelper
  def active_field_new_form(active_field)
    "active_fields/new_forms/#{active_field.type_name}"
  end

  def active_field_input(active_field)
    "active_fields/inputs/#{active_field.type_name}"
  end

  def render_active_field_new_form(active_field:)
    partial = active_field_new_form(active_field)

    render partial: partial, locals: { active_field: active_field }
  end

  def render_active_field_input(form:, record:, active_field:)
    partial = active_field_input(active_field)
    active_value = record.active_values.find { _1.active_field_id == active_field.id }

    render partial: partial, locals: { form: form, active_field: active_field, active_value: active_value }
  end
end
