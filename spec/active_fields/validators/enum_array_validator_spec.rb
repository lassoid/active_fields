# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::EnumArrayValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) do
    build(
      :enum_array_active_field,
      allowed_values: allowed_values,
      min_size: min_size,
      max_size: max_size,
    )
  end

  let(:allowed_values) { Array.new(rand(10..15)) { random_string(rand(5..10)) } }
  let(:min_size) { 0 }
  let(:max_size) { nil }

  include_examples "field_value_validate",
    -> { [nil, allowed_values.sample].sample },
    "not an array",
    -> { [:invalid] }
  include_examples "field_value_validate",
    -> { [[allowed_values.sample, nil], [allowed_values.sample, 7]].sample },
    "not an array of strings",
    -> { [:inclusion] }

  context "array size comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate", -> { allowed_values.sample(rand(1..9)) }, "an array of allowed strings"
    end

    context "with min" do
      let(:min_size) { rand(1..4) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { allowed_values.sample(min_size - 1) },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { allowed_values.sample(min_size) },
        "an array of strings with min size"
    end

    context "with max" do
      let(:max_size) { rand(5..9) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { allowed_values.sample(max_size) },
        "an array of strings with max size"
      include_examples "field_value_validate",
        -> { allowed_values.sample(max_size + 1) },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: max_size]] }
    end

    context "with both min and max" do
      let(:min_size) { rand(1..4) }
      let(:max_size) { rand(5..9) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { allowed_values.sample(min_size - 1) },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { allowed_values.sample(min_size) },
        "an array of strings with min size"
      include_examples "field_value_validate",
        -> { allowed_values.sample(max_size) },
        "an array of strings with max size"
      include_examples "field_value_validate",
        -> { allowed_values.sample(max_size + 1) },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: max_size]] }
    end
  end

  include_examples "field_value_validate",
    -> { allowed_values.sample(rand(1..allowed_values.size)) },
    "an array of allowed strings"
  include_examples "field_value_validate",
    -> { [allowed_values.sample, "#{allowed_values.sample} other"] },
    "an array containing a not allowed string",
    -> { [:inclusion] }
  include_examples "field_value_validate",
    -> { ["", allowed_values.sample] },
    "an array with an empty string",
    -> { [:inclusion] }

  context "when empty string allowed" do
    let(:allowed_values) { [""] + Array.new(2) { random_string(rand(5..10)) } }

    include_examples "field_value_validate", -> { ["", allowed_values.last] }, "an array with an empty string"
  end
end
