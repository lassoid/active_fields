# frozen_string_literal: true

require "resolv"

class IpArrayValidator < ActiveFields::Validators::BaseValidator
  private

  def perform_validation(value)
    unless value.is_a?(Array)
      errors << :invalid
      return
    end

    validate_size(value, min: options[:min_size], max: options[:max_size])

    value.each do |elem_value|
      if elem_value.is_a?(String)
        errors << :invalid unless elem_value.match?(Resolv::IPv4::Regex)
      else
        errors << :invalid
      end
    end
  end
end
