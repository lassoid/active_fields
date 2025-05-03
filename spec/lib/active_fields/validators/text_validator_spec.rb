# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::TextValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  it_behaves_like "field_value_validate", -> { nil }, "nil"
  it_behaves_like "field_value_validate",
    -> { [random_number, random_date, [random_string]].sample },
    "not a string or nil",
    -> { [:invalid] }

  context "when required" do
    let(:args) { { required: true } }

    it_behaves_like "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "length comparison" do
    context "without min and max" do
      let(:args) { {} }

      it_behaves_like "field_value_validate", -> { random_string }, "a string"
      it_behaves_like "field_value_validate", -> { "" }, "an empty string"
    end

    context "with min" do
      let(:args) { { min_length: rand(1..10) } }

      it_behaves_like "field_value_validate",
        -> { random_string(args[:min_length]) },
        "a string with min length"
      it_behaves_like "field_value_validate",
        -> { random_string(args[:min_length] + 1) },
        "a string with length greater than min"
      it_behaves_like "field_value_validate",
        -> { random_string(args[:min_length] - 1) },
        "a string with length less than min",
        -> { [[:too_short, count: args[:min_length]]] }
    end

    context "with max" do
      let(:args) { { max_length: rand(10..20) } }

      it_behaves_like "field_value_validate",
        -> { random_string(args[:max_length]) },
        "a string with max length"
      it_behaves_like "field_value_validate",
        -> { random_string(args[:max_length] - 1) },
        "a string with length less than max"
      it_behaves_like "field_value_validate",
        -> { random_string(args[:max_length] + 1) },
        "a string with length greater than max",
        -> { [[:too_long, count: args[:max_length]]] }
    end

    context "with both positive min and max" do
      let(:args) { { min_length: rand(1..10), max_length: rand(10..20) } }

      it_behaves_like "field_value_validate",
        -> { random_string(args[:min_length]) },
        "a string with min length"
      it_behaves_like "field_value_validate",
        -> { random_string(args[:max_length]) },
        "a string with max length"
      it_behaves_like "field_value_validate",
        -> { random_string(rand(args[:min_length]..args[:max_length])) },
        "a string with length between min and max"
      it_behaves_like "field_value_validate",
        -> { random_string(args[:min_length] - 1) },
        "a string with length less than min",
        -> { [[:too_short, count: args[:min_length]]] }
      it_behaves_like "field_value_validate",
        -> { random_string(args[:max_length] + 1) },
        "a string with length greater than max",
        -> { [[:too_long, count: args[:max_length]]] }
    end
  end
end
