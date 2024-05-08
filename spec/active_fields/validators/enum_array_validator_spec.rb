# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::EnumArrayValidator do
  subject(:validate) { object.validate(value) }

  factory = :enum_array_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate", -> { nil }, "nil", -> { [:invalid] }
  include_examples "field_value_validate",
    -> { active_field.allowed_values.sample },
    "not an array",
    -> { [:invalid] }

  include_examples "field_value_validate",
    -> { active_field.allowed_values.sample(rand(1..active_field.allowed_values.size)) },
    "an array of allowed strings"
  include_examples "field_value_validate",
    -> { [active_field.allowed_values.sample, "#{active_field.allowed_values.sample} other"] },
    "an array containing a not allowed string",
    -> { [:inclusion] }
  include_examples "field_value_validate",
    -> { [active_field.allowed_values.first, active_field.allowed_values.first] },
    "an array containing duplicates",
    -> { [:taken] }
  include_examples "field_value_validate",
    -> { ["", active_field.allowed_values.sample] },
    "an array with an empty string",
    -> { [:inclusion] }
  include_examples "field_value_validate",
    -> { [[active_field.allowed_values.sample, nil], [random_number, active_field.allowed_values.sample]].sample },
    "not an array of allowed strings",
    -> { [:inclusion] }

  context "array size comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { active_field.allowed_values.sample(rand(1..9)) },
        "an array of allowed strings"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min_size) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { active_field.allowed_values.sample(active_field.min_size - 1) },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { active_field.allowed_values.sample(active_field.min_size) },
        "an array of strings with min size"
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max_size) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { active_field.allowed_values.sample(active_field.max_size) },
        "an array of strings with max size"
      include_examples "field_value_validate",
        -> { active_field.allowed_values.sample(active_field.max_size + 1) },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: active_field.max_size]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min_size, :with_max_size) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { active_field.allowed_values.sample(active_field.min_size - 1) },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { active_field.allowed_values.sample(rand(active_field.min_size..active_field.max_size)) },
        "an array of strings with size between min and max"
      include_examples "field_value_validate",
        -> { active_field.allowed_values.sample(active_field.max_size + 1) },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: active_field.max_size]] }
    end
  end

  context "when empty string allowed" do
    let(:active_field) { build(factory).tap { _1.allowed_values += [""] } }

    include_examples "field_value_validate",
      -> { ["", active_field.allowed_values.first] },
      "an array with an empty string"
  end
end
