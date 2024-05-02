# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ActiveFields::Validators::DecimalArrayValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) do
    build(:decimal_array_active_field, min: min, max: max, min_size: min_size, max_size: max_size)
  end

  let(:min) { nil }
  let(:max) { nil }
  let(:min_size) { 0 }
  let(:max_size) { nil }

  include_examples "field_value_validate",
    -> { [nil, 1.5, [33.9, nil], ["test value", 7.77]].sample },
    "not an array of numbers",
    -> { [:invalid] }

  context "array size comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate", -> { Array.new(rand(1..9), &:to_d) }, "an array of numbers"
    end

    context "with min" do
      let(:min_size) { rand(1..4) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(min_size - 1, &:to_d) },
        "an array of numbers with too short size",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(min_size, &:to_d) },
        "an array of numbers with min size"
    end

    context "with max" do
      let(:max_size) { rand(5..9) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(max_size, &:to_d) },
        "an array of numbers with max size"
      include_examples "field_value_validate",
        -> { Array.new(max_size + 1, &:to_d) },
        "an array of numbers with exceeded size",
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
        -> { Array.new(min_size - 1, &:to_d) },
        "an array of numbers with too short size",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(min_size, &:to_d) },
        "an array of numbers with min size"
      include_examples "field_value_validate",
        -> { Array.new(max_size, &:to_d) },
        "an array of numbers with max size"
      include_examples "field_value_validate",
        -> { Array.new(max_size + 1, &:to_d) },
        "an array of numbers with exceeded size",
        -> { [[:size_too_long, count: max_size]] }
    end
  end

  context "element comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate", -> { Array.new(rand(1..9), &:to_d) }, "an array of numbers"
    end

    context "with min" do
      let(:min) { rand(1.0..10.0).round(5) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [min, min + 0.1] },
        "an array of numbers greater than or equal to min"
      include_examples "field_value_validate",
        -> { [min, min - 0.1] },
        "an array containing a number less than min",
        -> { [[:greater_than_or_equal_to, count: min]] }
    end

    context "with max" do
      let(:max) { rand(11.0..20.0).round(5) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [max, max - 0.1] },
        "an array of numbers less than or equal to max"
      include_examples "field_value_validate",
        -> { [max, max + 0.1] },
        "an array containing a number greater than max",
        -> { [[:less_than_or_equal_to, count: max]] }
    end

    context "with both min and max" do
      let(:min) { rand(1.0..10.0).round(5) }
      let(:max) { rand(11.0..20.0).round(5) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(2) { rand(min..max).round(5) } },
        "an array of numbers between min and max"
      include_examples "field_value_validate",
        -> { [min, min - 0.1] },
        "an array containing a number less than min",
        -> { [[:greater_than_or_equal_to, count: min]] }
      include_examples "field_value_validate",
        -> { [max, max + 0.1] },
        "an array containing a number greater than max",
        -> { [[:less_than_or_equal_to, count: max]] }
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
