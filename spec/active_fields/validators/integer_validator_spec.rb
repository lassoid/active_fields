# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::IntegerValidator do
  subject(:validate) { object.validate(value) }

  factory = :integer_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { [random_string, random_date, [random_number]].sample },
    "not a number or nil",
    -> { [:invalid] }

  context "when required" do
    let(:active_field) { build(factory, :required) }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "value comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { random_number }, "a number"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min) }

      include_examples "field_value_validate", -> { active_field.min }, "a min number"
      include_examples "field_value_validate", -> { active_field.min + 1 }, "a number greater than min"
      include_examples "field_value_validate",
        -> { active_field.min - 1 },
        "a number less than min",
        -> { [[:greater_than_or_equal_to, count: active_field.min]] }
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max) }

      include_examples "field_value_validate", -> { active_field.max }, "a max number"
      include_examples "field_value_validate", -> { active_field.max - 1 }, "a number less than max"
      include_examples "field_value_validate",
        -> { active_field.max + 1 },
        "a number greater than max",
        -> { [[:less_than_or_equal_to, count: active_field.max]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min, :with_max) }

      include_examples "field_value_validate", -> { active_field.min }, "a min number"
      include_examples "field_value_validate", -> { active_field.max }, "a max number"
      include_examples "field_value_validate",
        -> { rand(active_field.min..active_field.max) },
        "a number between min and max"
      include_examples "field_value_validate",
        -> { active_field.min - 1 },
        "a number less than min",
        -> { [[:greater_than_or_equal_to, count: active_field.min]] }
      include_examples "field_value_validate",
        -> { active_field.max + 1 },
        "a number greater than max",
        -> { [[:less_than_or_equal_to, count: active_field.max]] }
    end
  end
end
