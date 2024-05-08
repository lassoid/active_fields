# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DateValidator do
  subject(:validate) { object.validate(value) }

  factory = :date_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { [random_string, random_number, [random_date]].sample },
    "not a date or nil",
    -> { [:invalid] }

  context "when required" do
    let(:active_field) { build(factory, :required) }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "value comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { random_date }, "a date"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min) }

      include_examples "field_value_validate", -> { active_field.min }, "a min date"
      include_examples "field_value_validate", -> { active_field.min + 1 }, "a date greater than min"
      include_examples "field_value_validate",
        -> { active_field.min - 1 },
        "a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(active_field.min)]] }
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max) }

      include_examples "field_value_validate", -> { active_field.max }, "a max date"
      include_examples "field_value_validate", -> { active_field.max - 1 }, "a date less than max"
      include_examples "field_value_validate",
        -> { active_field.max + 1 },
        "a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(active_field.max)]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min, :with_max) }

      include_examples "field_value_validate", -> { active_field.min }, "a min date"
      include_examples "field_value_validate", -> { active_field.max }, "a max date"
      include_examples "field_value_validate",
        -> { rand(active_field.min..active_field.max) },
        "a date between min and max"
      include_examples "field_value_validate",
        -> { active_field.min - 1 },
        "a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(active_field.min)]] }
      include_examples "field_value_validate",
        -> { active_field.max + 1 },
        "a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(active_field.max)]] }
    end
  end
end
