# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::DateTimeValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  it_behaves_like "field_value_validate", -> { nil }, "nil"
  it_behaves_like "field_value_validate",
    -> { [random_string, random_number, [random_datetime]].sample },
    "not a datetime or nil",
    -> { [:invalid] }

  context "when required" do
    let(:args) { { required: true } }

    it_behaves_like "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "value comparison" do
    context "without min and max" do
      let(:args) { {} }

      it_behaves_like "field_value_validate", -> { random_datetime }, "a datetime"
    end

    context "with min" do
      let(:args) { { min: Time.current - rand(0..10).days } }

      it_behaves_like "field_value_validate", -> { args[:min] }, "a min datetime"
      it_behaves_like "field_value_validate", -> { args[:min] + 1.second }, "a datetime greater than min"
      it_behaves_like "field_value_validate",
        -> { args[:min] - 1.second },
        "a datetime less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(args[:min])]] }
    end

    context "with max" do
      let(:args) { { max: Time.current + rand(0..10).days } }

      it_behaves_like "field_value_validate", -> { args[:max] }, "a max datetime"
      it_behaves_like "field_value_validate", -> { args[:max] - 1.second }, "a datetime less than max"
      it_behaves_like "field_value_validate",
        -> { args[:max] + 1.second },
        "a datetime greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(args[:max])]] }
    end

    context "with both min and max" do
      let(:args) { { min: Time.current - rand(0..10).days, max: Time.current + rand(0..10).days } }

      it_behaves_like "field_value_validate", -> { args[:min] }, "a min datetime"
      it_behaves_like "field_value_validate", -> { args[:max] }, "a max datetime"
      it_behaves_like "field_value_validate",
        -> { rand(args[:min]..args[:max]) },
        "a datetime between min and max"
      it_behaves_like "field_value_validate",
        -> { args[:min] - 1.second },
        "a datetime less than min",
        -> { [[:greater_than_or_equal_to, count: I18n.l(args[:min])]] }
      it_behaves_like "field_value_validate",
        -> { args[:max] + 1.second },
        "a datetime greater than max",
        -> { [[:less_than_or_equal_to, count: I18n.l(args[:max])]] }
    end
  end
end
