# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DateTimeValidator do
  subject(:validate) { object.validate(value) }

  factory = :datetime_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { [random_string, random_number, [random_datetime]].sample },
    "not a datetime or nil",
    -> { [:invalid] }

  context "when required" do
    let(:active_field) { build(factory, :required) }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "value comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { random_datetime }, "a datetime"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min) }

      include_examples "field_value_validate", -> { active_field.min }, "a min datetime"
      include_examples "field_value_validate", -> { active_field.min + 1.second }, "a datetime greater than min"
      include_examples "field_value_validate",
        -> { active_field.min - 1.second },
        "a datetime less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(active_field.min)]] }
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max) }

      include_examples "field_value_validate", -> { active_field.max }, "a max datetime"
      include_examples "field_value_validate", -> { active_field.max - 1.second }, "a datetime less than max"
      include_examples "field_value_validate",
        -> { active_field.max + 1.second },
        "a datetime greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(active_field.max)]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min, :with_max) }

      include_examples "field_value_validate", -> { active_field.min }, "a min datetime"
      include_examples "field_value_validate", -> { active_field.max }, "a max datetime"
      include_examples "field_value_validate",
        -> { rand(active_field.min..active_field.max) },
        "a datetime between min and max"
      include_examples "field_value_validate",
        -> { active_field.min - 1.second },
        "a datetime less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(active_field.min)]] }
      include_examples "field_value_validate",
        -> { active_field.max + 1.second },
        "a datetime greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(active_field.max)]] }
    end
  end
end
