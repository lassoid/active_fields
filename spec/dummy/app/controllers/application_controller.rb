# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  private

  def policy(model)
    "#{model.model_name.name}Policy".constantize.new
  end

  def compact_array_params(params, permitted)
    permitted.each do |permitted_element|
      next unless permitted_element.is_a?(Hash)

      permitted_element.each do |key, value|
        next if value != []

        if params[key].is_a?(Array) && params[key].first == ""
          params[key] = params[key][1..-1]
        end
      end
    end

    params
  end
end
