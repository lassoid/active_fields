# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ActiveFields::Validators::DateArrayValidator do
  subject(:validate) { object.validate(value) }

  let(:max_size) { 5 }

  let(:object) { described_class.new(active_field) }
  let(:active_field) do
    build_stubbed(:date_array_active_field, min: min, max: max, min_size: min_size, max_size: max_size)
  end

  context "when min_size is zero" do
    let(:min_size) { 0 }

    context "without min and max" do
      let(:min) { nil }
      let(:max) { nil }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(max_size) { |n| Date.today + n } },
        "an array of dates"
      include_examples "field_value_validate",
        -> { Array.new(max_size + 1) { |n| Date.today + n } },
        "an array of dates with exceeded size",
        -> { [[:size_too_long, count: max_size]] }
      include_examples "field_value_validate",
        -> { [Date.today, [Date.today, nil], ["test value", Date.today]].sample },
        "not an array of dates",
        -> { [:invalid] }
    end

    context "with min" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { nil }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate", -> { [min, min + 1] }, "an array of allowed dates"
      include_examples "field_value_validate",
        -> { [min, min - 1] },
        "an array containing a date less than minimum",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { [Date.today, [Date.today, nil], ["test value", Date.today]].sample },
        "not an array of dates",
        -> { [:invalid] }
    end

    context "with max" do
      let(:min) { nil }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate", -> { [max, max - 1] }, "an array of allowed dates"
      include_examples "field_value_validate",
        -> { [max, max + 1] },
        "an array containing a date greater than maximum",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
      include_examples "field_value_validate",
        -> { [Date.today, [Date.today, nil], ["test value", Date.today]].sample },
        "not an array of dates",
        -> { [:invalid] }
    end

    context "with both min and max" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate", -> { (min..max).to_a.take(2) }, "an array of allowed dates"
      include_examples "field_value_validate",
        -> { [max, min - 1] },
        "an array containing a date less than minimum",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { [min, max + 1] },
        "an array containing a date greater than maximum",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
      include_examples "field_value_validate",
        -> { [Date.today, [Date.today, nil], ["test value", Date.today]].sample },
        "not an array of dates",
        -> { [:invalid] }
    end
  end

  context "when min_size is not zero" do
    let(:min_size) { 1 }

    context "without min and max" do
      let(:min) { nil }
      let(:max) { nil }

      include_examples "field_value_validate", -> { [] }, "an empty array", -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(max_size) { |n| Date.today + n } },
        "an array of dates"
      include_examples "field_value_validate",
        -> { Array.new(max_size + 1) { |n| Date.today + n } },
        "an array of dates with exceeded size",
        -> { [[:size_too_long, count: max_size]] }
      include_examples "field_value_validate",
        -> { [Date.today, [Date.today, nil], ["test value", Date.today]].sample },
        "not an array of dates",
        -> { [:invalid] }
    end

    context "with min" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { nil }

      include_examples "field_value_validate", -> { [] }, "an empty array", -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate", -> { [min, min + 1] }, "an array of allowed dates"
      include_examples "field_value_validate",
        -> { [min, min - 1] },
        "an array containing a date less than minimum",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { [Date.today, [Date.today, nil], ["test value", Date.today]].sample },
        "not an array of dates",
        -> { [:invalid] }
    end

    context "with max" do
      let(:min) { nil }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { [] }, "an empty array", -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate", -> { [max, max - 1] }, "an array of allowed dates"
      include_examples "field_value_validate",
        -> { [max, max + 1] },
        "an array containing a date greater than maximum",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
      include_examples "field_value_validate",
        -> { [Date.today, [Date.today, nil], ["test value", Date.today]].sample },
        "not an array of dates",
        -> { [:invalid] }
    end

    context "with both min and max" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { [] }, "an empty array", -> { [[:size_too_short, count: min_size]] }
      include_examples "field_value_validate", -> { (min..max).to_a.take(2) }, "an array of allowed dates"
      include_examples "field_value_validate",
        -> { [max, min - 1] },
        "an array containing a date less than minimum",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { [min, max + 1] },
        "an array containing a date greater than maximum",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
      include_examples "field_value_validate",
        -> { [Date.today, [Date.today, nil], ["test value", Date.today]].sample },
        "not an array of dates",
        -> { [:invalid] }
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
