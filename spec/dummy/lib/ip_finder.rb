# frozen_string_literal: true

class IpFinder < ActiveFields::Finders::SingularFinder
  def search(operator:, value:)
    value = IpCaster.new.deserialize(value)

    case operator.to_s
    when *ActiveFields::OPS[:eq]
      scope.where(eq(casted_value_field("text"), value))
    when *ActiveFields::OPS[:not_eq]
      scope.where(not_eq(casted_value_field("text"), value))
    else
      operator_not_found!(operator)
    end
  end
end
