# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::BooleanValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  include_examples "field_value_validate",
    -> { [random_integer, random_date, "true", []].sample },
    "not a boolean or nil",
    -> { [:invalid] }

  context "when required" do
    let(:args) { { required: true } }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:exclusion] }
    include_examples "field_value_validate", -> { true }, "true"
    include_examples "field_value_validate", -> { false }, "false", -> { [:required] }
  end

  context "when nullable" do
    let(:args) { { nullable: true } }

    include_examples "field_value_validate", -> { nil }, "nil"
    include_examples "field_value_validate", -> { true }, "true"
    include_examples "field_value_validate", -> { false }, "false"
  end

  context "when required and nullable" do
    let(:args) { { required: true, nullable: true } }

    include_examples "field_value_validate", -> { nil }, "nil"
    include_examples "field_value_validate", -> { true }, "true"
    include_examples "field_value_validate", -> { false }, "false", -> { [:required] }
  end

  context "when not required and not nullable" do
    let(:args) { {} }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:exclusion] }
    include_examples "field_value_validate", -> { true }, "true"
    include_examples "field_value_validate", -> { false }, "false"
  end
end
