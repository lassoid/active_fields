# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::TextValidator do
  subject(:validate) { object.validate(value) }

  factory = :text_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { [random_number, random_date, [random_string]].sample },
    "not a string or nil",
    -> { [:invalid] }

  context "when required" do
    let(:active_field) { build(factory, :required) }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "length comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { random_string }, "a string"
      include_examples "field_value_validate", -> { "" }, "an empty string"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min_length) }

      include_examples "field_value_validate",
        -> { random_string(active_field.min_length) },
        "a string with min length"
      include_examples "field_value_validate",
        -> { random_string(active_field.min_length + 1) },
        "a string with length greater than min"
      include_examples "field_value_validate",
        -> { random_string(active_field.min_length - 1) },
        "a string with length less than min",
        -> { [[:too_short, count: active_field.min_length]] }
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max_length) }

      include_examples "field_value_validate",
        -> { random_string(active_field.max_length) },
        "a string with max length"
      include_examples "field_value_validate",
        -> { random_string(active_field.max_length - 1) },
        "a string with length less than max"
      include_examples "field_value_validate",
        -> { random_string(active_field.max_length + 1) },
        "a string with length greater than max",
        -> { [[:too_long, count: active_field.max_length]] }
    end

    context "with both positive min and max" do
      let(:active_field) { build(factory, :with_min_length, :with_max_length) }

      include_examples "field_value_validate",
        -> { random_string(active_field.min_length) },
        "a string with min length"
      include_examples "field_value_validate",
        -> { random_string(active_field.max_length) },
        "a string with max length"
      include_examples "field_value_validate",
        -> { random_string(rand(active_field.min_length..active_field.max_length)) },
        "a string with length between min and max"
      include_examples "field_value_validate",
        -> { random_string(active_field.min_length - 1) },
        "a string with length less than min",
        -> { [[:too_short, count: active_field.min_length]] }
      include_examples "field_value_validate",
        -> { random_string(active_field.max_length + 1) },
        "a string with length greater than max",
        -> { [[:too_long, count: active_field.max_length]] }
    end
  end
end
