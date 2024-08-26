# frozen_string_literal: true

module ApplicationHelper
  def render_array_input(form:, name:, value:, label_text: nil, field_method:, field_opts: {})
    render partial: "shared/array_input", locals: {
      form: form,
      name: name,
      value: value,
      label_text: label_text,
      field_method: field_method,
      field_opts: field_opts,
    }
  end

  def render_active_field_form(active_field:)
    partial = active_field_form(active_field)

    render partial: partial, locals: { active_field: active_field }
  end

  def render_active_value_input(form:, active_value:)
    partial = active_value_input(active_value.active_field)

    render partial: partial, locals: { form: form, active_value: active_value, active_field: active_value.active_field }
  end

  def active_field_form(active_field)
    "active_fields/forms/#{active_field.type_name}"
  end

  def active_value_input(active_field)
    "active_fields/value_inputs/#{active_field.type_name}"
  end
end
