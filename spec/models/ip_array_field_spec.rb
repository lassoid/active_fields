# frozen_string_literal: true

RSpec.describe IpArrayField do
  factory = :ip_array_field

  it_behaves_like "active_field",
    factory: factory,
    available_traits: [],
    validator_class: "IpArrayValidator",
    caster_class: "IpArrayCaster",
    finder_class: nil
end
