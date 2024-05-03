# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Text do
  it_behaves_like "active_field", factory: :text_active_field

  include_examples "store_attribute_boolean", :required, :options, described_class
  include_examples "store_attribute_integer", :min_length, :options, described_class
  include_examples "store_attribute_integer", :max_length, :options, described_class

  it "has a valid factory" do
    expect(build(:text_active_field)).to be_valid
  end

  context "validations" do
    subject(:record) { build(:text_active_field, min_length: min_length, max_length: max_length) }

    let(:min_length) { nil }
    let(:max_length) { nil }

    describe "#validate_default_value" do
      before do
        validator = instance_double(ActiveFields::Validators::TextValidator, errors: validator_errors)
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

    describe "#max_length" do
      context "with min_length" do
        let(:min_length) { rand(0..10) }

        context "when max_length is nil" do
          let(:max_length) { nil }

          it { is_expected.to be_valid }
        end

        context "when max_length is less than min_length" do
          let(:max_length) { min_length - 1 }

          it { is_expected.not_to be_valid }

          it "adds errors from validator" do
            record.valid?

            expect(record.errors.of_kind?(:max_length, :greater_than_or_equal_to)).to be(true)
          end
        end

        context "when max_length is equal to min_length" do
          let(:max_length) { min_length }

          it { is_expected.to be_valid }
        end

        context "when max_length is greater than min_length" do
          let(:max_length) { min_length + 1 }

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
      include_examples "field_value_add", :text_active_field
      include_examples "field_value_add", :text_active_field, :with_min_length
      include_examples "field_value_add", :text_active_field, :with_max_length
      include_examples "field_value_add", :text_active_field, :with_min_length, :with_max_length
      include_examples "field_value_add", :text_active_field, :required
      include_examples "field_value_add", :text_active_field, :required, :with_min_length
      include_examples "field_value_add", :text_active_field, :required, :with_max_length
      include_examples "field_value_add", :text_active_field, :required, :with_min_length, :with_max_length
    end
  end
end
