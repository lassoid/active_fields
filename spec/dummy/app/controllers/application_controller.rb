# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  private

  def policy(model)
    "#{model.model_name.name}Policy".constantize.new
  end
end
