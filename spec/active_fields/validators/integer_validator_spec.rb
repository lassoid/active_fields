# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::IntegerValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(:integer_active_field, required: required, min: min, max: max) }

  let(:required) { false }
  let(:min) { nil }
  let(:max) { nil }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { [random_string, random_date, [random_integer]].sample },
    "not a number or nil",
    -> { [:invalid] }

  context "when required" do
    let(:required) { true }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "value comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { rand(1..10) }, "a number"
    end

    context "with min" do
      let(:min) { rand(1..10) }

      include_examples "field_value_validate", -> { min }, "a min number"
      include_examples "field_value_validate", -> { min + 1 }, "a number greater than min"
      include_examples "field_value_validate",
        -> { min - 1 },
        "a number less than min",
        -> { [[:greater_than_or_equal_to, count: min]] }
    end

    context "with max" do
      let(:max) { rand(11..20) }

      include_examples "field_value_validate", -> { max }, "a max number"
      include_examples "field_value_validate", -> { max - 1 }, "a number less than max"
      include_examples "field_value_validate",
        -> { max + 1 },
        "a number greater than max",
        -> { [[:less_than_or_equal_to, count: max]] }
    end

    context "with both min and max" do
      let(:min) { rand(1..10) }
      let(:max) { rand(11..20) }

      include_examples "field_value_validate", -> { min }, "a min number"
      include_examples "field_value_validate", -> { max }, "a max number"
      include_examples "field_value_validate", -> { rand(min..max) }, "a number between min and max"
      include_examples "field_value_validate",
        -> { min - 1 },
        "a number less than min",
        -> { [[:greater_than_or_equal_to, count: min]] }
      include_examples "field_value_validate",
        -> { max + 1 },
        "a number greater than max",
        -> { [[:less_than_or_equal_to, count: max]] }
    end
  end
end
