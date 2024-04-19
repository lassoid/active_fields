# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::EnumValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(:enum_active_field, required: required, allowed_values: allowed_values) }

  let(:required) { false }
  let(:allowed_values) { Array.new(rand(1..5)) { random_string(rand(5..10)) } }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { [rand(0..10), Date.current, [allowed_values.sample]].sample },
    "not a string or nil",
    -> { [:inclusion] }

  include_examples "field_value_validate", -> { allowed_values.sample }, "an allowed string"
  include_examples "field_value_validate",
    -> { "#{allowed_values.sample} other" },
    "a not allowed string",
    -> { [:inclusion] }
  include_examples "field_value_validate", -> { "" }, "an empty string", -> { [:inclusion] }

  context "when required" do
    let(:required) { true }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "when empty string allowed" do
    let(:allowed_values) { [""] + Array.new(rand(1..5)) { random_string(rand(5..10)) } }

    include_examples "field_value_validate", -> { "" }, "an empty string"
  end
end
