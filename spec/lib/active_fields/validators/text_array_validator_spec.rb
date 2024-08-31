# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::TextArrayValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  include_examples "field_value_validate", -> { nil }, "nil", -> { [:invalid] }
  include_examples "field_value_validate", -> { random_string }, "not an array", -> { [:invalid] }
  include_examples "field_value_validate",
    -> { [[random_string, nil], [random_number, random_string]].sample },
    "not an array of strings",
    -> { [:invalid] }

  context "array size comparison" do
    context "without min and max" do
      let(:args) { {} }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { random_string } },
        "an array of strings"
    end

    context "with min" do
      let(:args) { { min_size: rand(1..5) } }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: args[:min_size]]] }
      include_examples "field_value_validate",
        -> { Array.new(args[:min_size] - 1) { random_string } },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: args[:min_size]]] }
      include_examples "field_value_validate",
        -> { Array.new(args[:min_size]) { random_string } },
        "an array of strings with min size"
    end

    context "with max" do
      let(:args) { { max_size: rand(5..10) } }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(args[:max_size]) { random_string } },
        "an array of strings with max size"
      include_examples "field_value_validate",
        -> { Array.new(args[:max_size] + 1) { random_string } },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: args[:max_size]]] }
    end

    context "with both min and max" do
      let(:args) { { min_size: rand(1..5), max_size: rand(5..10) } }

      include_examples "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: args[:min_size]]] }
      include_examples "field_value_validate",
        -> { Array.new(args[:min_size] - 1) { random_string } },
        "an array of strings with too short size",
        -> { [[:size_too_short, count: args[:min_size]]] }
      include_examples "field_value_validate",
        -> { Array.new(rand(args[:min_size]..args[:max_size])) { random_string } },
        "an array of strings with size between min and max"
      include_examples "field_value_validate",
        -> { Array.new(args[:max_size] + 1) { random_string } },
        "an array of strings with exceeded size",
        -> { [[:size_too_long, count: args[:max_size]]] }
    end
  end

  context "element length comparison" do
    context "without min and max" do
      let(:args) { {} }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(rand(1..9)) { random_string } },
        "an array of strings"
    end

    context "with min" do
      let(:args) { { min_length: rand(1..10) } }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [random_string(args[:min_length]), random_string(args[:min_length] + 1)] },
        "an array of strings with length greater than or equal to min"
      include_examples "field_value_validate",
        -> { [random_string(args[:min_length]), random_string(args[:min_length] - 1)] },
        "an array containing a string with length less than min",
        -> { [[:too_short, count: args[:min_length]]] }
    end

    context "with max" do
      let(:args) { { max_length: rand(10..20) } }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { [random_string(args[:max_length]), random_string(args[:max_length] - 1)] },
        "an array of strings with length less than or equal to max"
      include_examples "field_value_validate",
        -> { [random_string(args[:max_length]), random_string(args[:max_length] + 1)] },
        "an array containing a string with length greater than max",
        -> { [[:too_long, count: args[:max_length]]] }
    end

    context "with both min and max" do
      let(:args) { { min_length: rand(1..10), max_length: rand(10..20) } }

      include_examples "field_value_validate", -> { [] }, "an empty array"
      include_examples "field_value_validate",
        -> { Array.new(2) { random_string(rand(args[:min_length]..args[:max_length])) } },
        "an array of strings with length between min and max"
      include_examples "field_value_validate",
        -> { [random_string(args[:min_length]), random_string(args[:min_length] - 1)] },
        "an array containing a string with length less than min",
        -> { [[:too_short, count: args[:min_length]]] }
      include_examples "field_value_validate",
        -> { [random_string(args[:max_length]), random_string(args[:max_length] + 1)] },
        "an array containing a string with length greater than max",
        -> { [[:too_long, count: args[:max_length]]] }
    end
  end
end
