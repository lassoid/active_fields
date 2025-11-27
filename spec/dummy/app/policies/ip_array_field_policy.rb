# frozen_string_literal: true

class IpArrayFieldPolicy < ApplicationPolicy
  def permitted_attributes_for_create
    [
      :customizable_type,
      :name,
      :scope,
      :min_size,
      :max_size,
      default_value: [],
    ]
  end

  def permitted_attributes_for_update
    [:name, default_value: []]
  end
end
