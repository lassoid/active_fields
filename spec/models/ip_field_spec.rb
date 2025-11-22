# frozen_string_literal: true

RSpec.describe IpField do
  factory = :ip_field # rubocop:disable RSpec/LeakyLocalVariable

  it_behaves_like "active_field",
    factory: factory,
    available_traits: %i[required],
    validator_class: "IpValidator",
    caster_class: "IpCaster",
    finder_class: "IpFinder"
end
