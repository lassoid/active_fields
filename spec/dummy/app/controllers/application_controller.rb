# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper ActiveFieldsHelper

  helper_method :active_fields_finders_params

  protect_from_forgery prepend: true

  private

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

  def policy(model)
    "#{model.model_name.name}Policy".constantize.new
  end

  def compact_array_param(value)
    if value.first == ""
      value[1..-1]
    else
      value
    end
  end
end
