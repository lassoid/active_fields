# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DateValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  it_behaves_like "field_value_validate", -> { nil }, "nil"
  it_behaves_like "field_value_validate",
    -> { [random_string, random_number, [random_date]].sample },
    "not a date or nil",
    -> { [:invalid] }

  context "when required" do
    let(:args) { { required: true } }

    it_behaves_like "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "value comparison" do
    context "without min and max" do
      let(:args) { {} }

      it_behaves_like "field_value_validate", -> { random_date }, "a date"
    end

    context "with min" do
      let(:args) { { min: Date.current - rand(0..10).days } }

      it_behaves_like "field_value_validate", -> { args[:min] }, "a min date"
      it_behaves_like "field_value_validate", -> { args[:min] + 1.day }, "a date greater than min"
      it_behaves_like "field_value_validate",
        -> { args[:min] - 1.day },
        "a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(args[:min])]] }
    end

    context "with max" do
      let(:args) { { max: Date.current + rand(0..10).days } }

      it_behaves_like "field_value_validate", -> { args[:max] }, "a max date"
      it_behaves_like "field_value_validate", -> { args[:max] - 1.day }, "a date less than max"
      it_behaves_like "field_value_validate",
        -> { args[:max] + 1.day },
        "a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(args[:max])]] }
    end

    context "with both min and max" do
      let(:args) { { min: Date.current - rand(0..10).days, max: Date.current + rand(0..10).days } }

      it_behaves_like "field_value_validate", -> { args[:min] }, "a min date"
      it_behaves_like "field_value_validate", -> { args[:max] }, "a max date"
      it_behaves_like "field_value_validate",
        -> { rand(args[:min]..args[:max]) },
        "a date between min and max"
      it_behaves_like "field_value_validate",
        -> { args[:min] - 1.day },
        "a date less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(args[:min])]] }
      it_behaves_like "field_value_validate",
        -> { args[:max] + 1.day },
        "a date greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(args[:max])]] }
    end
  end
end
