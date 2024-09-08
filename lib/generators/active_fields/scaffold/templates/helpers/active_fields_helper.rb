# frozen_string_literal: true

module ActiveFieldsHelper
  def render_array_field(form:, name:, value:, field_method:, field_opts: {})
    render partial: "shared/array_field", locals: {
      form: form,
      name: name,
      value: value,
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
    "active_fields/values/inputs/#{active_field.type_name}"
  end
end
