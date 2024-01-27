# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::EnumValidator do
  subject(:validate) { object.validate(value) }

  factory = :enum_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  include_examples "field_value_validate", -> { nil }, "nil"
  include_examples "field_value_validate",
    -> { [random_number, random_date, [active_field.allowed_values.sample]].sample },
    "not a string or nil",
    -> { [:inclusion] }

  include_examples "field_value_validate", -> { active_field.allowed_values.sample }, "an allowed string"
  include_examples "field_value_validate",
    -> { "#{active_field.allowed_values.sample} other" },
    "a not allowed string",
    -> { [:inclusion] }
  include_examples "field_value_validate", -> { "" }, "an empty string", -> { [:inclusion] }

  context "when required" do
    let(:active_field) { build(factory, :required) }

    include_examples "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end

  context "when empty string allowed" do
    let(:active_field) { build(factory).tap { _1.allowed_values += [""] } }

    include_examples "field_value_validate", -> { "" }, "an empty string"
  end
end
