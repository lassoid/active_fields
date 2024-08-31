# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DecimalValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { [random_string, random_date, [random_number]].sample },
    "not a number or nil",
    -> { [:invalid] }

  context "when required" do
    let(:args) { { required: true } }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "value comparison" do
    context "without min and max" do
      let(:args) { {} }

      include_examples "field_value_validate", -> { random_number }, "a number"
    end

    context "with min" do
      let(:args) { { min: rand(-10.0..0.0) } }

      include_examples "field_value_validate", -> { args[:min] }, "a min number"
      include_examples "field_value_validate", -> { args[:min] + 0.1 }, "a number greater than min"
      include_examples "field_value_validate",
        -> { args[:min] - 0.1 },
        "a number less than min",
        -> { [[:greater_than_or_equal_to, count: args[:min]]] }
    end

    context "with max" do
      let(:args) { { max: rand(0.0..10.0) } }

      include_examples "field_value_validate", -> { args[:max] }, "a max number"
      include_examples "field_value_validate", -> { args[:max] - 0.1 }, "a number less than max"
      include_examples "field_value_validate",
        -> { args[:max] + 0.1 },
        "a number greater than max",
        -> { [[:less_than_or_equal_to, count: args[:max]]] }
    end

    context "with both min and max" do
      let(:args) { { min: rand(-10.0..0.0), max: rand(0.0..10.0) } }

      include_examples "field_value_validate", -> { args[:min] }, "a min number"
      include_examples "field_value_validate", -> { args[:max] }, "a max number"
      include_examples "field_value_validate",
        -> { rand(args[:min]..args[:max]) },
        "a number between min and max"
      include_examples "field_value_validate",
        -> { args[:min] - 0.1 },
        "a number less than min",
        -> { [[:greater_than_or_equal_to, count: args[:min]]] }
      include_examples "field_value_validate",
        -> { args[:max] + 0.1 },
        "a number greater than max",
        -> { [[:less_than_or_equal_to, count: args[:max]]] }
    end
  end
end
