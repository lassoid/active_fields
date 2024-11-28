# frozen_string_literal: true

class IpFinder < ActiveFields::Finders::BaseFinder
  def search(operator:, value:)
    value = IpCaster.new.deserialize(value)

    case operator.to_s
    when "=", "eq"
      active_values_cte.where(casted_value_field("text").eq(value))
    when "!=", "not_eq"
      active_values_cte.where(casted_value_field("text").not_eq(value))
    else
      operator_not_found!(operator)
    end
  end
end
