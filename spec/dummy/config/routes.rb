# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActiveFields::Engine => "/active_fields"
end
