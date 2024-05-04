# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ActiveFields::Validators::DateArrayValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) do
    build(:date_array_active_field, min: min, max: max, min_size: min_size, max_size: max_size)
  end

  let(:min) { nil }
  let(:max) { nil }
  let(:min_size) { 0 }
  let(:max_size) { nil }

  include_examples "field_value_validate",
    -> { [nil, random_date, [random_date, nil], [random_string, random_date]].sample },
    "not an array of dates",
    -> { [:invalid] }

  context "array size comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { |n| Date.today + n } },
        "an array of dates"
    end

    context "with min" do
      let(:min_size) { rand(1..4) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(min_size - 1) { |n| Date.today + n } },
        "an array of dates with too short size",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(min_size) { |n| Date.today + n } },
        "an array of dates with min size"
    end

    context "with max" do
      let(:max_size) { rand(5..9) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(max_size) { |n| Date.today + n } },
        "an array of dates with max size"
      include_examples "field_value_validate",
        -> { Array.new(max_size + 1) { |n| Date.today + n } },
        "an array of dates with exceeded size",
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
        -> { Array.new(min_size - 1) { |n| Date.today + n } },
        "an array of dates with too short size",
        -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(min_size) { |n| Date.today + n } },
        "an array of dates with min size"
      include_examples "field_value_validate",
        -> { Array.new(max_size) { |n| Date.today + n } },
        "an array of dates with max size"
      include_examples "field_value_validate",
        -> { Array.new(max_size + 1) { |n| Date.today + n } },
        "an array of dates with exceeded size",
        -> { [[:size_too_long, count: max_size]] }
    end
  end

  context "element comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { |n| Date.today + n } },
        "an array of dates"
    end

    context "with min" do
      let(:min) { Date.today - rand(1..10) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [min, min + 1] },
        "an array of dates greater than or equal to min"
      include_examples "field_value_validate",
        -> { [min, min - 1] },
        "an array containing a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
    end

    context "with max" do
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [max, max - 1] },
        "an array of dates less than or equal to max"
      include_examples "field_value_validate",
        -> { [max, max + 1] },
        "an array containing a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
    end

    context "with both min and max" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { (min..max).to_a.take(2) },
        "an array of dates between min and max"
      include_examples "field_value_validate",
        -> { [min, min - 1] },
        "an array containing a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { [max, max + 1] },
        "an array containing a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
