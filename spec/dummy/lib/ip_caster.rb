# frozen_string_literal: true

class IpCaster < ActiveFields::Casters::BaseCaster
  def serialize(value)
    cast(value)
  end

  def deserialize(value)
    cast(value)
  end

  private

  def cast(value)
    value&.to_s
  end
end
