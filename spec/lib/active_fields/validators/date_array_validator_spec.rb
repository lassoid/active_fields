# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DateArrayValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  it_behaves_like "field_value_validate", -> { nil }, "nil", -> { [:invalid] }
  it_behaves_like "field_value_validate", -> { random_date }, "not an array", -> { [:invalid] }
  it_behaves_like "field_value_validate",
    -> { [[random_date, nil], [random_date.to_s, random_date]].sample },
    "not an array of dates",
    -> { [:invalid] }

  context "array size comparison" do
    context "without min and max" do
      let(:args) { {} }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { Array.new(rand(1..9)) { random_date } },
        "an array of dates"
    end

    context "with min" do
      let(:args) { { min_size: rand(1..5) } }

      it_behaves_like "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: args[:min_size]]] }
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:min_size] - 1) { random_date } },
        "an array of dates with too short size",
        -> { [[:size_too_short, count: args[:min_size]]] }
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:min_size]) { random_date } },
        "an array of dates with min size"
    end

    context "with max" do
      let(:args) { { max_size: rand(5..10) } }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:max_size]) { random_date } },
        "an array of dates with max size"
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:max_size] + 1) { random_date } },
        "an array of dates with exceeded size",
        -> { [[:size_too_long, count: args[:max_size]]] }
    end

    context "with both min and max" do
      let(:args) { { min_size: rand(1..5), max_size: rand(5..10) } }

      it_behaves_like "field_value_validate",
        -> { [] },
        "an empty array",
        -> { [[:size_too_short, count: args[:min_size]]] }
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:min_size] - 1) { random_date } },
        "an array of dates with too short size",
        -> { [[:size_too_short, count: args[:min_size]]] }
      it_behaves_like "field_value_validate",
        -> { Array.new(rand(args[:min_size]..args[:max_size])) { random_date } },
        "an array of dates with size between min and max"
      it_behaves_like "field_value_validate",
        -> { Array.new(args[:max_size] + 1) { random_date } },
        "an array of dates with exceeded size",
        -> { [[:size_too_long, count: args[:max_size]]] }
    end
  end

  context "element value comparison" do
    context "without min and max" do
      let(:args) { {} }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { Array.new(rand(1..9)) { random_date } },
        "an array of dates"
    end

    context "with min" do
      let(:args) { { min: Date.current - rand(0..10).days } }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { [args[:min], args[:min] + 1.day] },
        "an array of dates greater than or equal to min"
      it_behaves_like "field_value_validate",
        -> { [args[:min], args[:min] - 1.day] },
        "an array containing a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(args[:min])]] }
    end

    context "with max" do
      let(:args) { { max: Date.current + rand(0..10).days } }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { [args[:max], args[:max] - 1.day] },
        "an array of dates less than or equal to max"
      it_behaves_like "field_value_validate",
        -> { [args[:max], args[:max] + 1.day] },
        "an array containing a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(args[:max])]] }
    end

    context "with both min and max" do
      let(:args) { { min: Date.current - rand(0..10).days, max: Date.current + rand(0..10).days } }

      it_behaves_like "field_value_validate", -> { [] }, "an empty array"
      it_behaves_like "field_value_validate",
        -> { Array.new(2) { rand(args[:min]..args[:max]) } },
        "an array of dates between min and max"
      it_behaves_like "field_value_validate",
        -> { [args[:min], args[:min] - 1.day] },
        "an array containing a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(args[:min])]] }
      it_behaves_like "field_value_validate",
        -> { [args[:max], args[:max] + 1.day] },
        "an array containing a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(args[:max])]] }
    end
  end
end
