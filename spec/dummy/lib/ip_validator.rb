# frozen_string_literal: true

require "resolv"

class IpValidator < ActiveFields::Validators::BaseValidator
  private

  def perform_validation(value)
    if value.nil?
      errors << :required if options[:required]
    elsif value.is_a?(String)
      errors << :invalid unless value.match?(Resolv::IPv4::Regex)
    else
      errors << :invalid
    end
  end
end
