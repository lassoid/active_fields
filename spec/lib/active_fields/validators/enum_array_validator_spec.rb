# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::EnumArrayValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { { allowed_values: Array.new(rand(11..15)) { TestMethods.random_string } }.merge(other_args) }
  let(:other_args) { {} }

  include_examples "field_value_validate", -> { nil }, "nil", -> { [:invalid] }
  include_examples "field_value_validate",
    -> { args[:allowed_values].sample },
    "not an array",
    -> { [:invalid] }

  include_examples "field_value_validate",
    -> { args[:allowed_values].sample(rand(1..args[:allowed_values].size)) },
    "an array of allowed strings"
  include_examples "field_value_validate",
    -> { [args[:allowed_values].sample, "#{args[:allowed_values].sample} other"] },
    "an array containing a not allowed string",
    -> { [:inclusion] }
  include_examples "field_value_validate",
    -> { [args[:allowed_values].first, args[:allowed_values].first] },
    "an array containing duplicates",
    -> { [:duplicate] }
  include_examples "field_value_validate",
    -> { ["", args[:allowed_values].sample] },
    "an array with an empty string",
    -> { [:inclusion] }
  include_examples "field_value_validate",
    -> { [[args[:allowed_values].sample, nil], [random_number, args[:allowed_values].sample]].sample },
    "not an array of allowed strings",
    -> { [:inclusion] }

  context "array size comparison" do
    context "without min and max" do
      let(:other_args) { {} }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { args[:allowed_values].sample(rand(1..9)) },
        "an array of allowed strings"
    end

    context "with min" do
      let(:other_args) { { min_size: rand(1..5) } }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: args[:min_size]]] }
      include_examples "field_value_validate",
        -> { args[:allowed_values].sample(args[:min_size] - 1) },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: args[:min_size]]] }
      include_examples "field_value_validate",
        -> { args[:allowed_values].sample(args[:min_size]) },
        "an array of strings with min size"
    end

    context "with max" do
      let(:other_args) { { max_size: rand(5..10) } }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { args[:allowed_values].sample(args[:max_size]) },
        "an array of strings with max size"
      include_examples "field_value_validate",
        -> { args[:allowed_values].sample(args[:max_size] + 1) },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: args[:max_size]]] }
    end

    context "with both min and max" do
      let(:other_args) { { min_size: rand(1..5), max_size: rand(5..10) } }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: args[:min_size]]] }
      include_examples "field_value_validate",
        -> { args[:allowed_values].sample(args[:min_size] - 1) },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: args[:min_size]]] }
      include_examples "field_value_validate",
        -> { args[:allowed_values].sample(rand(args[:min_size]..args[:max_size])) },
        "an array of strings with size between min and max"
      include_examples "field_value_validate",
        -> { args[:allowed_values].sample(args[:max_size] + 1) },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: args[:max_size]]] }
    end
  end
end
