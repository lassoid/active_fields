# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::IntegerArrayValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  it_behaves_like "field_value_validate", -> { nil }, "nil", -> { [:invalid] }
  it_behaves_like "field_value_validate", -> { random_number }, "not an array", -> { [:invalid] }
  it_behaves_like "field_value_validate",
    -> { [[random_number, nil], [random_number.to_s, random_number]].sample },
    "not an array of numbers",
    -> { [:invalid] }

  context "array size comparison" do
    context "without min and max" do
      let(:args) { {} }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { Array.new(rand(1..9)) { random_number } },
        "an array of numbers"
    end

    context "with min" do
      let(:args) { { min_size: rand(1..5) } }

      it_behaves_like "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: args[:min_size]]] }
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:min_size] - 1) { random_number } },
        "an array of numbers with too short size",
        -> { [[:size_too_short, count: args[:min_size]]] }
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:min_size]) { random_number } },
        "an array of numbers with min size"
    end

    context "with max" do
      let(:args) { { max_size: rand(5..10) } }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:max_size]) { random_number } },
        "an array of numbers with max size"
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:max_size] + 1) { random_number } },
        "an array of numbers with exceeded size",
        -> { [[:size_too_long, count: args[:max_size]]] }
    end

    context "with both min and max" do
      let(:args) { { min_size: rand(1..5), max_size: rand(5..10) } }

      it_behaves_like "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: args[:min_size]]] }
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:min_size] - 1) { random_number } },
        "an array of numbers with too short size",
        -> { [[:size_too_short, count: args[:min_size]]] }
      it_behaves_like "field_value_validate",
        -> { Array.new(rand(args[:min_size]..args[:max_size])) { random_number } },
        "an array of numbers with size between min and max"
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:max_size] + 1) { random_number } },
        "an array of numbers with exceeded size",
        -> { [[:size_too_long, count: args[:max_size]]] }
    end
  end

  context "element value comparison" do
    context "without min and max" do
      let(:args) { {} }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { Array.new(rand(1..9)) { random_number } },
        "an array of numbers"
    end

    context "with min" do
      let(:args) { { min: rand(-10..0) } }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { [args[:min], args[:min] + 1] },
        "an array of numbers greater than or equal to min"
      it_behaves_like "field_value_validate",
        -> { [args[:min], args[:min] - 1] },
        "an array containing a number less than min",
        -> { [[:greater_than_or_equal_to, count: args[:min]]] }
    end

    context "with max" do
      let(:args) { { max: rand(0..10) } }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { [args[:max], args[:max] - 1] },
        "an array of numbers less than or equal to max"
      it_behaves_like "field_value_validate",
        -> { [args[:max], args[:max] + 1] },
        "an array containing a number greater than max",
        -> { [[:less_than_or_equal_to, count: args[:max]]] }
    end

    context "with both min and max" do
      let(:args) { { min: rand(-10..0), max: rand(0..10) } }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { Array.new(2) { rand(args[:min]..args[:max]) } },
        "an array of numbers between min and max"
      it_behaves_like "field_value_validate",
        -> { [args[:min], args[:min] - 1] },
        "an array containing a number less than min",
        -> { [[:greater_than_or_equal_to, count: args[:min]]] }
      it_behaves_like "field_value_validate",
        -> { [args[:max], args[:max] + 1] },
        "an array containing a number greater than max",
        -> { [[:less_than_or_equal_to, count: args[:max]]] }
    end
  end
end
