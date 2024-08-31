# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DateTimeArrayValidator do
  subject(:validate) { object.validate(value) }

  factory = :datetime_array_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate", -> { nil }, "nil", -> { [:invalid] }
  include_examples "field_value_validate", -> { random_datetime }, "not an array", -> { [:invalid] }
  include_examples "field_value_validate",
    -> { [[random_datetime, nil], [random_datetime.to_s, random_datetime]].sample },
    "not an array of datetimes",
    -> { [:invalid] }

  context "array size comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { random_datetime } },
        "an array of datetimes"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min_size) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(active_field.min_size - 1) { random_datetime } },
        "an array of datetimes with too short size",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(active_field.min_size) { random_datetime } },
        "an array of datetimes with min size"
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max_size) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(active_field.max_size) { random_datetime } },
        "an array of datetimes with max size"
      include_examples "field_value_validate",
        -> { Array.new(active_field.max_size + 1) { random_datetime } },
        "an array of datetimes with exceeded size",
        -> { [[:size_too_long, count: active_field.max_size]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min_size, :with_max_size) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(active_field.min_size - 1) { random_datetime } },
        "an array of datetimes with too short size",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(rand(active_field.min_size..active_field.max_size)) { random_datetime } },
        "an array of datetimes with size between min and max"
      include_examples "field_value_validate",
        -> { Array.new(active_field.max_size + 1) { random_datetime } },
        "an array of datetimes with exceeded size",
        -> { [[:size_too_long, count: active_field.max_size]] }
    end
  end

  context "element value comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { random_datetime } },
        "an array of datetimes"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [active_field.min, active_field.min + 1.second] },
        "an array of datetimes greater than or equal to min"
      include_examples "field_value_validate",
        -> { [active_field.min, active_field.min - 1.second] },
        "an array containing a datetime less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(active_field.min)]] }
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [active_field.max, active_field.max - 1.second] },
        "an array of datetimes less than or equal to max"
      include_examples "field_value_validate",
        -> { [active_field.max, active_field.max + 1.second] },
        "an array containing a datetime greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(active_field.max)]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min, :with_max) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(2) { rand(active_field.min..active_field.max) } },
        "an array of datetimes between min and max"
      include_examples "field_value_validate",
        -> { [active_field.min, active_field.min - 1.second] },
        "an array containing a datetime less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(active_field.min)]] }
      include_examples "field_value_validate",
        -> { [active_field.max, active_field.max + 1.second] },
        "an array containing a datetime greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(active_field.max)]] }
    end
  end
end
