# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DateValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) { build_stubbed(:date_active_field, required: required, min: min, max: max) }

  let(:required) { false }
  let(:min) { nil }
  let(:max) { nil }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { ["invalid", 1, [Date.today]].sample },
    "not a date or nil",
    -> { [:invalid] }

  context "when required" do
    let(:required) { true }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "value comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { Date.today }, "a date"
    end

    context "with min" do
      let(:min) { Date.today - rand(1..10) }

      include_examples "field_value_validate", -> { min }, "a min date"
      include_examples "field_value_validate", -> { min + 1 }, "a date greater than min"
      include_examples "field_value_validate",
        -> { min - 1 },
        "a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
    end

    context "with max" do
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { max }, "a max date"
      include_examples "field_value_validate", -> { max - 1 }, "a date less than max"
      include_examples "field_value_validate",
        -> { max + 1 },
        "a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
    end

    context "with both min and max" do
      let(:min) { Date.today - rand(1..10) }
      let(:max) { Date.today + rand(1..10) }

      include_examples "field_value_validate", -> { min }, "a min date"
      include_examples "field_value_validate", -> { max }, "a max date"
      include_examples "field_value_validate", -> { (min..max).to_a.sample }, "a date between min and max"
      include_examples "field_value_validate",
        -> { min - 1 },
        "a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(min)]] }
      include_examples "field_value_validate",
        -> { max + 1 },
        "a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(max)]] }
    end
  end
end
