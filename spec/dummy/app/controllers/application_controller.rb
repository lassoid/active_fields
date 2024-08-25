# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  private

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
