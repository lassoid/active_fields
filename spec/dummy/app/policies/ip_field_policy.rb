# frozen_string_literal: true

class IpFieldPolicy < ApplicationPolicy
  def permitted_attributes_for_create
    %i[customizable_type name required default_value]
  end

  def permitted_attributes_for_update
    %i[name]
  end
end
