# frozen_string_literal: true

module ActiveFieldsControllerConcern
  extend ActiveSupport::Concern

  included do
    helper_method :active_fields_finders_params
  end

  def active_fields_finders_params
    @active_fields_finders_params ||=
      params.permit(
        f: [
          :n,
          :name,
          :op,
          :operator,
          :v,
          :value,
          v: [],
          value: [],
        ],
      )[:f] || {}
  end

  def compact_array_param(value)
    if value.first == ""
      value[1..-1]
    else
      value
    end
  end
end
