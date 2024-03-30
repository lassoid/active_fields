# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::BooleanValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(:boolean_active_field, required: required, nullable: nullable) }

  context "when not required" do
    let(:required) { false }

    context "when not nullable" do
      let(:nullable) { false }

      include_examples "field_value_validate", -> { nil }, "nil", [:exclusion]
      include_examples "field_value_validate", -> { true }, "true"
      include_examples "field_value_validate", -> { false }, "false"
      include_examples "field_value_validate",
        -> { [rand(0..10), Date.current, "true", []].sample },
        "not a boolean or nil",
        [:invalid]
    end

    context "when nullable" do
      let(:nullable) { true }

      include_examples "field_value_validate", -> { nil }, "nil"
      include_examples "field_value_validate", -> { true }, "true"
      include_examples "field_value_validate", -> { false }, "false"
      include_examples "field_value_validate",
        -> { [rand(0..10), Date.current, "true", []].sample },
        "not a boolean or nil",
        [:invalid]
    end
  end

  context "when required" do
    let(:required) { true }

    context "when not nullable" do
      let(:nullable) { false }

      include_examples "field_value_validate", -> { nil }, "nil", [:exclusion]
      include_examples "field_value_validate", -> { true }, "true"
      include_examples "field_value_validate", -> { false }, "false", [:required]
      include_examples "field_value_validate",
        -> { [rand(0..10), Date.current, "true", []].sample },
        "not a boolean or nil",
        [:invalid]
    end

    context "when nullable" do
      let(:nullable) { true }

      include_examples "field_value_validate", -> { nil }, "nil"
      include_examples "field_value_validate", -> { true }, "true"
      include_examples "field_value_validate", -> { false }, "false", [:required]
      include_examples "field_value_validate",
        -> { [rand(0..10), Date.current, "true", []].sample },
        "not a boolean or nil",
        [:invalid]
    end
  end
end
