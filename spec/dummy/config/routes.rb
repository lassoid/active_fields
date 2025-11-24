# frozen_string_literal: true

Rails.application.routes.draw do
  # mount ActiveFields::Engine => "/active_fields"

  root to: "home#index"

  resources :users, only: %i[index new create edit update destroy]
  resources :authors, only: %i[index new create edit update destroy]
  resources :groups, only: %i[index new create edit update destroy]
  resources :posts, only: %i[index new create edit update destroy]
  resources :active_fields
end
