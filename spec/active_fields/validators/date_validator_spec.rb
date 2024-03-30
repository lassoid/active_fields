# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DateValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) { build_stubbed(:date_active_field, required: required, min: min, max: max) }

  context "when not required" do
    let(:required) { false }

    context "without min and max" do
      let(:min) { nil }
      let(:max) { nil }

      include_examples "field_value_validate", -> { nil }, "nil"
      include_examples "field_value_validate", -> { Date.today }, "a date"
      include_examples "field_value_validate",
        -> { ["invalid", 1, [Date.today]].sample },
        "not a date or nil",
        -> { [:invalid] }
    end

    context "with min" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { nil }

      include_examples "field_value_validate", -> { nil }, "nil"
      include_examples "field_value_validate", -> { min }, "an allowed minimum"
      include_examples "field_value_validate", -> { min + 1 }, "a date greater than minimum"
      include_examples "field_value_validate",
        -> { min - 1 },
        "a date less than minimum",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { ["invalid", 1, [Date.today]].sample },
        "not a date or nil",
        -> { [:invalid] }
    end

    context "with max" do
      let(:min) { nil }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { nil }, "nil"
      include_examples "field_value_validate", -> { max }, "an allowed maximum"
      include_examples "field_value_validate", -> { max - 1 }, "a date less than maximum"
      include_examples "field_value_validate",
        -> { max + 1 },
        "a date greater than maximum",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
      include_examples "field_value_validate",
        -> { ["invalid", 1, [Date.today]].sample },
        "not a date or nil",
        -> { [:invalid] }
    end

    context "with both min and max" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { nil }, "nil"
      include_examples "field_value_validate", -> { min }, "an allowed minimum"
      include_examples "field_value_validate", -> { max }, "an allowed maximum"
      include_examples "field_value_validate", -> { (min..max).to_a.sample }, "a date between minimum and maximum"
      include_examples "field_value_validate",
        -> { min - 1 },
        "a date less than minimum",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { max + 1 },
        "a date greater than maximum",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
      include_examples "field_value_validate",
        -> { ["invalid", 1, [Date.today]].sample },
        "not a date or nil",
        -> { [:invalid] }
    end
  end

  context "when required" do
    let(:required) { true }

    context "without min and max" do
      let(:min) { nil }
      let(:max) { nil }

      include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
      include_examples "field_value_validate", -> { Date.today }, "a date"
      include_examples "field_value_validate",
        -> { ["invalid", 1, [Date.today]].sample },
        "not a date or nil",
        -> { [:invalid] }
    end

    context "with min" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { nil }

      include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
      include_examples "field_value_validate", -> { min }, "an allowed minimum"
      include_examples "field_value_validate", -> { min + 1 }, "a date greater than minimum"
      include_examples "field_value_validate",
        -> { min - 1 },
        "a date less than minimum",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { ["invalid", 1, [Date.today]].sample },
        "not a date or nil",
        -> { [:invalid] }
    end

    context "with max" do
      let(:min) { nil }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
      include_examples "field_value_validate", -> { max }, "an allowed maximum"
      include_examples "field_value_validate", -> { max - 1 }, "a date less than maximum"
      include_examples "field_value_validate",
        -> { max + 1 },
        "a date greater than maximum",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
      include_examples "field_value_validate",
        -> { ["invalid", 1, [Date.today]].sample },
        "not a date or nil",
        -> { [:invalid] }
    end

    context "with both min and max" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
      include_examples "field_value_validate", -> { min }, "an allowed minimum"
      include_examples "field_value_validate", -> { max }, "an allowed maximum"
      include_examples "field_value_validate", -> { (min..max).to_a.sample }, "a date between minimum and maximum"
      include_examples "field_value_validate",
        -> { min - 1 },
        "a date less than minimum",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { max + 1 },
        "a date greater than maximum",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
      include_examples "field_value_validate",
        -> { ["invalid", 1, [Date.today]].sample },
        "not a date or nil",
        -> { [:invalid] }
    end
  end
end
