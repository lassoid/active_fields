# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::EnumValidator do
  subject(:validate) { object.validate(value) }

  let(:object) { described_class.new(**args) }
  let(:args) { { allowed_values: Array.new(rand(11..15)) { TestMethods.random_string } }.merge(other_args) }
  let(:other_args) { {} }

  it_behaves_like "field_value_validate", -> { nil }, "nil"
  it_behaves_like "field_value_validate",
    -> { [random_number, random_date, [args[:allowed_values].sample]].sample },
    "not a string or nil",
    -> { [:inclusion] }

  it_behaves_like "field_value_validate", -> { args[:allowed_values].sample }, "an allowed string"
  it_behaves_like "field_value_validate",
    -> { "#{args[:allowed_values].sample} other" },
    "a not allowed string",
    -> { [:inclusion] }
  it_behaves_like "field_value_validate", -> { "" }, "an empty string", -> { [:inclusion] }

  context "when required" do
    let(:other_args) { { required: true } }

    it_behaves_like "field_value_validate", -> { nil }, "nil", -> { [:required] }
  end
end
