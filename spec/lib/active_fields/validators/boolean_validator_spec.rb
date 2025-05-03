# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::BooleanValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  it_behaves_like "field_value_validate",
    -> { [random_integer, random_date, "true", []].sample },
    "not a boolean or nil",
    -> { [:invalid] }

  context "when required" do
    let(:args) { { required: true } }

    it_behaves_like "field_value_validate", -> { nil }, "nil", -> { [:exclusion] }
    it_behaves_like "field_value_validate", -> { true }, "true"
    it_behaves_like "field_value_validate", -> { false }, "false", -> { [:required] }
  end

  context "when nullable" do
    let(:args) { { nullable: true } }

    it_behaves_like "field_value_validate", -> { nil }, "nil"
    it_behaves_like "field_value_validate", -> { true }, "true"
    it_behaves_like "field_value_validate", -> { false }, "false"
  end

  context "when required and nullable" do
    let(:args) { { required: true, nullable: true } }

    it_behaves_like "field_value_validate", -> { nil }, "nil"
    it_behaves_like "field_value_validate", -> { true }, "true"
    it_behaves_like "field_value_validate", -> { false }, "false", -> { [:required] }
  end

  context "when not required and not nullable" do
    let(:args) { {} }

    it_behaves_like "field_value_validate", -> { nil }, "nil", -> { [:exclusion] }
    it_behaves_like "field_value_validate", -> { true }, "true"
    it_behaves_like "field_value_validate", -> { false }, "false"
  end
end
