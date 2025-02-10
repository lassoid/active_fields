# frozen_string_literal: true

class IpFinder < ActiveFields::Finders::SingularFinder
  operation :eq, operator: ActiveFields::OPS[:eq] do |value|
    scope.where(eq(casted_value_field("text"), cast(value)))
  end
  operation :not_eq, operator: ActiveFields::OPS[:not_eq] do |value|
    scope.where(not_eq(casted_value_field("text"), cast(value)))
  end

  def cast(value)
    IpCaster.new.deserialize(value)
  end
end
