# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::TextValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(:text_active_field, required: required, min_length: min_length, max_length: max_length) }

  let(:required) { false }
  let(:min_length) { nil }
  let(:max_length) { nil }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { [rand(-10..10), Date.current, ["test value"]].sample },
    "not a string or nil",
    -> { [:invalid] }

  context "when required" do
    let(:required) { true }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
    include_examples "field_value_validate", -> { "" }, "an empty string"
  end

  context "length comparison" do
    context "without min and max" do
      include_examples "field_value_validate", -> { random_string(rand(1..10)) }, "a string"
    end

    context "with zero min" do
      let(:min_length) { 0 }

      include_examples "field_value_validate", -> { "" }, "an empty string"
    end

    context "with positive min" do
      let(:min_length) { rand(1..10) }

      include_examples "field_value_validate", -> { random_string(min_length) }, "a string with min length"
      include_examples "field_value_validate",
        -> { random_string(min_length + 1) },
        "a string with length greater than min"
      include_examples "field_value_validate",
        -> { random_string(min_length - 1) },
        "a string with length less than min",
        -> { [[:too_short, count: min_length]] }
    end

    context "with max" do
      let(:max_length) { rand(11..20) }

      include_examples "field_value_validate", -> { random_string(max_length) }, "a string with max length"
      include_examples "field_value_validate",
        -> { random_string(max_length - 1) },
        "a string with length less than max"
      include_examples "field_value_validate",
        -> { random_string(max_length + 1) },
        "a string with length greater than max",
        -> { [[:too_long, count: max_length]] }
    end

    context "with both positive min and max" do
      let(:min_length) { rand(1..10) }
      let(:max_length) { rand(11..20) }

      include_examples "field_value_validate", -> { random_string(min_length) }, "a string with min length"
      include_examples "field_value_validate", -> { random_string(max_length) }, "a string with max length"
      include_examples "field_value_validate",
        -> { random_string(rand(min_length..max_length)) },
        "a string with length between min and max"
      include_examples "field_value_validate",
        -> { random_string(min_length - 1) },
        "a string with length less than min",
        -> { [[:too_short, count: min_length]] }
      include_examples "field_value_validate",
        -> { random_string(max_length + 1) },
        "a string with length greater than max",
        -> { [[:too_long, count: max_length]] }
    end
  end
end
