# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ActiveFields::Validators::TextArrayValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) do
    build(
      :text_array_active_field,
      min_length: min_length,
      max_length: max_length,
      min_size: min_size,
      max_size: max_size,
    )
  end

  let(:min_length) { nil }
  let(:max_length) { nil }
  let(:min_size) { 0 }
  let(:max_size) { nil }

  include_examples "field_value_validate",
    -> { [nil, random_string, [random_string, nil], [random_string, 7]].sample },
    "not an array of strings",
    -> { [:invalid] }

  context "array size comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate", -> { Array.new(rand(1..9), &:to_s) }, "an array of strings"
    end

    context "with min" do
      let(:min_size) { rand(1..4) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(min_size - 1, &:to_s) },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(min_size, &:to_s) },
        "an array of strings with min size"
    end

    context "with max" do
      let(:max_size) { rand(5..9) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(max_size, &:to_s) },
        "an array of strings with max size"
      include_examples "field_value_validate",
        -> { Array.new(max_size + 1, &:to_s) },
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
        -> { Array.new(min_size - 1, &:to_s) },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(min_size, &:to_s) },
        "an array of strings with min size"
      include_examples "field_value_validate",
        -> { Array.new(max_size, &:to_s) },
        "an array of strings with max size"
      include_examples "field_value_validate",
        -> { Array.new(max_size + 1, &:to_s) },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: max_size]] }
    end
  end

  context "element comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate", -> { Array.new(rand(1..9), &:to_s) }, "an array of strings"
    end

    context "with min" do
      let(:min_length) { rand(1..10) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [random_string(min_length), random_string(min_length + 1)] },
        "an array of strings greater than or equal to min"
      include_examples "field_value_validate",
        -> { [random_string(min_length), random_string(min_length - 1)] },
        "an array containing a string less than min",
        -> { [[:too_short, count: min_length]] }
    end

    context "with max" do
      let(:max_length) { rand(11..20) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [random_string(max_length), random_string(max_length - 1)] },
        "an array of strings less than or equal to max"
      include_examples "field_value_validate",
        -> { [random_string(max_length), random_string(max_length + 1)] },
        "an array containing a string greater than max",
        -> { [[:too_long, count: max_length]] }
    end

    context "with both min and max" do
      let(:min_length) { rand(1..10) }
      let(:max_length) { rand(11..20) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(2) { random_string(rand(min_length..max_length)) } },
        "an array of strings between min and max"
      include_examples "field_value_validate",
        -> { [random_string(min_length), random_string(min_length - 1)] },
        "an array containing a string less than min",
        -> { [[:too_short, count: min_length]] }
      include_examples "field_value_validate",
        -> { [random_string(max_length), random_string(max_length + 1)] },
        "an array containing a string greater than max",
        -> { [[:too_long, count: max_length]] }
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
