# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Integer do
  it_behaves_like "active_field", factory: :integer_active_field

  include_examples "store_attribute_boolean", :required, :options, described_class
  include_examples "store_attribute_integer", :min, :options, described_class
  include_examples "store_attribute_integer", :max, :options, described_class

  it "has a valid factory" do
    expect(build(:integer_active_field)).to be_valid
  end

  context "validations" do
    subject(:record) { build(:integer_active_field, min: min, max: max) }

    let(:min) { nil }
    let(:max) { nil }

    describe "#validate_default_value" do
      before do
        validator = instance_double(ActiveFields::Validators::IntegerValidator, errors: validator_errors)
        # rubocop:disable RSpec/SubjectStub
        allow(record).to receive(:value_validator).and_return(validator)
        # rubocop:enable RSpec/SubjectStub
        allow(validator).to receive(:validate).with(record.default_value).and_return(validator_errors.empty?)
      end

      context "when validator returns success" do
        let(:validator_errors) { Set.new }

        it { is_expected.to be_valid }
      end

      context "when validator returns error" do
        let(:validator_errors) { Set.new([:invalid, [:greater_than, count: 1]]) }

        it { is_expected.not_to be_valid }

        it "adds errors from validator" do
          record.valid?

          validator_errors.each do |error|
            expect(record.errors.added?(:default_value, *error)).to be(true)
          end
        end
      end
    end

    describe "#max" do
      context "with min" do
        let(:min) { rand(-10..10) }

        context "when max is nil" do
          let(:max) { nil }

          it { is_expected.to be_valid }
        end

        context "when max is less than min" do
          let(:max) { min - 1 }

          it { is_expected.not_to be_valid }

          it "adds errors from validator" do
            record.valid?

            expect(record.errors.of_kind?(:max, :greater_than_or_equal_to)).to be(true)
          end
        end

        context "when max is equal to min" do
          let(:max) { min }

          it { is_expected.to be_valid }
        end

        context "when max is greater than min" do
          let(:max) { min + 1 }

          it { is_expected.to be_valid }
        end
      end
    end
  end

  context "callbacks" do
    describe "after_initialize #set_defaults" do
      let(:record) { described_class.new(required: required) }
      let(:required) { nil }

      context "when required is nil" do
        it "sets false" do
          expect(record.required).to be(false)
        end
      end

      context "when required is not nil" do
        let(:required) { [true, false].sample }

        it "doesn't change column" do
          expect(record.required).to be(required)
        end
      end
    end

    describe "after_create #add_field_to_records" do
      include_examples "field_value_add", :integer_active_field
      include_examples "field_value_add", :integer_active_field, :with_min
      include_examples "field_value_add", :integer_active_field, :with_max
      include_examples "field_value_add", :integer_active_field, :with_min, :with_max
      include_examples "field_value_add", :integer_active_field, :required
      include_examples "field_value_add", :integer_active_field, :required, :with_min
      include_examples "field_value_add", :integer_active_field, :required, :with_max
      include_examples "field_value_add", :integer_active_field, :required, :with_min, :with_max
    end
  end
end
