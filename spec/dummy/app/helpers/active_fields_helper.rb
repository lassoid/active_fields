# frozen_string_literal: true

module ActiveFieldsHelper
  ARRAY_SIZE_OPERATIONS = %i[size_eq size_not_eq size_gt size_gteq size_lt size_lteq].freeze

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

  def render_active_fields_finders_form(active_fields:, url:)
    render partial: "active_fields/finders/form", locals: { active_fields: active_fields, url: url }
  end

  def active_field_finder_input_types(active_field:)
    return [] if active_field.value_finder_class.nil?

    types = [active_field.type_name]
    types += [:array_size] if active_field.value_finder_class.operations.intersect?(ARRAY_SIZE_OPERATIONS)

    types
  end

  def render_active_field_finder_input(form:, type:, active_field:, template: false, selected: {})
    if type == :array_size
      operations = active_field.value_finder_class.operations & ARRAY_SIZE_OPERATIONS
      partial = "active_fields/finders/inputs/array_size"
    else
      operations = active_field.value_finder_class.operations - ARRAY_SIZE_OPERATIONS
      partial = "active_fields/finders/inputs/#{type}"
    end

    render partial: partial, locals: {
      form: form,
      active_field: active_field,
      operations: operations,
      template: template,
      selected: selected,
    }
  end

  def render_selected_active_field_finder_input(form:, active_fields:, finder_params:)
    active_field_name = finder_params[:n] || finder_params[:name]
    operator = finder_params[:op] || finder_params[:operator]
    value = finder_params[:v] || finder_params[:value]

    active_field = active_fields.find { |active_field| active_field.name == active_field_name }
    return if active_field&.value_finder_class.nil?

    operation = active_field.value_finder_class.operation_for(operator)

    type =
      if ARRAY_SIZE_OPERATIONS.include?(operation)
        :array_size
      else
        active_field.type_name
      end

    render_active_field_finder_input(
      form: form,
      type: type,
      active_field: active_field,
      template: false,
      selected: { operation: operation, value: value },
    )
  end

  def active_field_form(active_field)
    "active_fields/forms/#{active_field.type_name}"
  end

  def active_value_input(active_field)
    "active_fields/values/inputs/#{active_field.type_name}"
  end
end
