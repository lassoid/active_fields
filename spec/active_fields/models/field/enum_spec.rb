# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Enum do
  it_behaves_like "active_field", factory: :enum_active_field

  include_examples "store_attribute_boolean", :required, :options, described_class
  include_examples "store_attribute_text_array", :allowed_values, :options, described_class

  it "has a valid factory" do
    expect(build(:enum_active_field)).to be_valid
  end

  context "validations" do
    subject(:record) { build(:enum_active_field) }

    describe "#validate_allowed_values" do
      subject(:record) do
        build(:enum_active_field, allowed_values: allowed_values)
      end

      context "when allowed_values is nil" do
        let(:allowed_values) { nil }

        it { is_expected.not_to be_valid }

        it "adds errors" do
          record.valid?

          expect(record.errors.added?(:allowed_values, :blank)).to be(true)
        end
      end

      context "when allowed_values is an empty array" do
        let(:allowed_values) { [] }

        it { is_expected.not_to be_valid }

        it "adds errors" do
          record.valid?

          expect(record.errors.added?(:allowed_values, :blank)).to be(true)
        end
      end

      context "when allowed_values contains not a string" do
        let(:allowed_values) { [random_string, nil] }

        it { is_expected.not_to be_valid }

        it "adds errors" do
          record.valid?

          expect(record.errors.added?(:allowed_values, :invalid)).to be(true)
        end
      end

      context "when allowed_values is not an array" do
        let(:allowed_values) { [random_integer, random_string, random_date].sample }

        it { is_expected.not_to be_valid }

        it "adds errors" do
          record.valid?

          expect(record.errors.added?(:allowed_values, :blank)).to be(true)
        end
      end

      context "when allowed_values is an array of strings" do
        let(:allowed_values) { ["", random_string] }

        it { is_expected.to be_valid }
      end
    end
  end

  context "callbacks" do
    describe "after_initialize #set_defaults" do
      let(:record) { described_class.new(required: required, allowed_values: allowed_values) }
      let(:required) { nil }
      let(:allowed_values) { nil }

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

      context "when allowed_values is nil" do
        it "sets empty array" do
          expect(record.allowed_values).to eq([])
        end
      end

      context "when allowed_values is not nil" do
        let(:allowed_values) { [random_string] }

        it "doesn't change column" do
          expect(record.allowed_values).to eq(allowed_values)
        end
      end
    end

    describe "after_create #add_field_to_records" do
      include_examples "field_value_add", :enum_active_field
      include_examples "field_value_add", :enum_active_field, :required
    end
  end
end
