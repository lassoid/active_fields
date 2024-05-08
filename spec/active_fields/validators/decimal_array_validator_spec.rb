# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DecimalArrayValidator do
  subject(:validate) { object.validate(value) }

  factory = :decimal_array_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate", -> { nil }, "nil", -> { [:invalid] }
  include_examples "field_value_validate", -> { random_number }, "not an array", -> { [:invalid] }
  include_examples "field_value_validate",
    -> { [[random_number, nil], [random_number.to_s, random_number]].sample },
    "not an array of numbers",
    -> { [:invalid] }

  context "array size comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { random_number } },
        "an array of numbers"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min_size) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(active_field.min_size - 1) { random_number } },
        "an array of numbers with too short size",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(active_field.min_size) { random_number } },
        "an array of numbers with min size"
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max_size) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(active_field.max_size) { random_number } },
        "an array of numbers with max size"
      include_examples "field_value_validate",
        -> { Array.new(active_field.max_size + 1) { random_number } },
        "an array of numbers with exceeded size",
        -> { [[:size_too_long, count: active_field.max_size]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min_size, :with_max_size) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(active_field.min_size - 1) { random_number } },
        "an array of numbers with too short size",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(rand(active_field.min_size..active_field.max_size)) { random_number } },
        "an array of numbers with size between min and max"
      include_examples "field_value_validate",
        -> { Array.new(active_field.max_size + 1) { random_number } },
        "an array of numbers with exceeded size",
        -> { [[:size_too_long, count: active_field.max_size]] }
    end
  end

  context "element value comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { random_number } },
        "an array of numbers"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [active_field.min, active_field.min + 0.1] },
        "an array of numbers greater than or equal to min"
      include_examples "field_value_validate",
        -> { [active_field.min, active_field.min - 0.1] },
        "an array containing a number less than min",
        -> { [[:greater_than_or_equal_to, count: active_field.min]] }
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [active_field.max, active_field.max - 0.1] },
        "an array of numbers less than or equal to max"
      include_examples "field_value_validate",
        -> { [active_field.max, active_field.max + 0.1] },
        "an array containing a number greater than max",
        -> { [[:less_than_or_equal_to, count: active_field.max]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min, :with_max) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(2) { rand(active_field.min..active_field.max) } },
        "an array of numbers between min and max"
      include_examples "field_value_validate",
        -> { [active_field.min, active_field.min - 0.1] },
        "an array containing a number less than min",
        -> { [[:greater_than_or_equal_to, count: active_field.min]] }
      include_examples "field_value_validate",
        -> { [active_field.max, active_field.max + 0.1] },
        "an array containing a number greater than max",
        -> { [[:less_than_or_equal_to, count: active_field.max]] }
    end
  end
end
