# frozen_string_literal: true

class IpArrayCaster < IpCaster
  def serialize(value)
    return unless value.is_a?(Array)

    value.map { |element| super(element) }
  end

  def deserialize(value)
    return unless value.is_a?(Array)

    value.map { |element| super(element) }
  end
end
