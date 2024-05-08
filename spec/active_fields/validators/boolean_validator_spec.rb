# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::BooleanValidator do
  subject(:validate) { object.validate(value) }

  factory = :boolean_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate",
    -> { [random_integer, random_date, "true", []].sample },
    "not a boolean or nil",
    -> { [:invalid] }

  context "when required" do
    let(:active_field) { build(factory, :required) }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:exclusion] }
    include_examples "field_value_validate", -> { true }, "true"
    include_examples "field_value_validate", -> { false }, "false", -> { [:required] }
  end

  context "when nullable" do
    let(:active_field) { build(factory, :nullable) }

    include_examples "field_value_validate", -> { nil }, "nil"
    include_examples "field_value_validate", -> { true }, "true"
    include_examples "field_value_validate", -> { false }, "false"
  end

  context "when required and nullable" do
    let(:active_field) { build(factory, :required, :nullable) }

    include_examples "field_value_validate", -> { nil }, "nil"
    include_examples "field_value_validate", -> { true }, "true"
    include_examples "field_value_validate", -> { false }, "false", -> { [:required] }
  end

  context "when not required and not nullable" do
    let(:active_field) { build(factory) }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:exclusion] }
    include_examples "field_value_validate", -> { true }, "true"
    include_examples "field_value_validate", -> { false }, "false"
  end
end
