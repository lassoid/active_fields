# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::TextArrayValidator do
  subject(:validate) { object.validate(value) }

  factory = :text_array_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate", -> { nil }, "nil", -> { [:invalid] }
  include_examples "field_value_validate", -> { random_string }, "not an array", -> { [:invalid] }
  include_examples "field_value_validate",
    -> { [[random_string, nil], [random_number, random_string]].sample },
    "not an array of strings",
    -> { [:invalid] }

  context "array size comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { random_string } },
        "an array of strings"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min_size) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(active_field.min_size - 1) { random_string } },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(active_field.min_size) { random_string } },
        "an array of strings with min size"
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max_size) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(active_field.max_size) { random_string } },
        "an array of strings with max size"
      include_examples "field_value_validate",
        -> { Array.new(active_field.max_size + 1) { random_string } },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: active_field.max_size]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min_size, :with_max_size) }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(active_field.min_size - 1) { random_string } },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: active_field.min_size]] }
      include_examples "field_value_validate",
        -> { Array.new(rand(active_field.min_size..active_field.max_size)) { random_string } },
        "an array of strings with size between min and max"
      include_examples "field_value_validate",
        -> { Array.new(active_field.max_size + 1) { random_string } },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: active_field.max_size]] }
    end
  end

  context "element length comparison" do
    context "without min and max" do
      let(:active_field) { build(factory) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { random_string } },
        "an array of strings"
    end

    context "with min" do
      let(:active_field) { build(factory, :with_min_length) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [random_string(active_field.min_length), random_string(active_field.min_length + 1)] },
        "an array of strings with length greater than or equal to min"
      include_examples "field_value_validate",
        -> { [random_string(active_field.min_length), random_string(active_field.min_length - 1)] },
        "an array containing a string with length less than min",
        -> { [[:too_short, count: active_field.min_length]] }
    end

    context "with max" do
      let(:active_field) { build(factory, :with_max_length) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [random_string(active_field.max_length), random_string(active_field.max_length - 1)] },
        "an array of strings with length less than or equal to max"
      include_examples "field_value_validate",
        -> { [random_string(active_field.max_length), random_string(active_field.max_length + 1)] },
        "an array containing a string with length greater than max",
        -> { [[:too_long, count: active_field.max_length]] }
    end

    context "with both min and max" do
      let(:active_field) { build(factory, :with_min_length, :with_max_length) }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(2) { random_string(rand(active_field.min_length..active_field.max_length)) } },
        "an array of strings with length between min and max"
      include_examples "field_value_validate",
        -> { [random_string(active_field.min_length), random_string(active_field.min_length - 1)] },
        "an array containing a string with length less than min",
        -> { [[:too_short, count: active_field.min_length]] }
      include_examples "field_value_validate",
        -> { [random_string(active_field.max_length), random_string(active_field.max_length + 1)] },
        "an array containing a string with length greater than max",
        -> { [[:too_long, count: active_field.max_length]] }
    end
  end
end
