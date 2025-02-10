# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActiveFieldsControllerConcern
  helper ActiveFieldsHelper

  protect_from_forgery prepend: true

  private

  def policy(model)
    "#{model.model_name.name}Policy".constantize.new
  end
end
