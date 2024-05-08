# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Integer do
  factory = :integer_active_field

  it_behaves_like "active_field", factory: factory

  include_examples "store_attribute_boolean", :required, :options, described_class
  include_examples "store_attribute_integer", :min, :options, described_class
  include_examples "store_attribute_integer", :max, :options, described_class

  it "has a valid factory" do
    expect(build(factory)).to be_valid
  end

  context "validations" do
    let(:record) { build(factory, min: min, max: max) }

    describe "#max" do
      context "without min" do
        let(:min) { nil }

        context "without max" do
          let(:max) { nil }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end

        context "with max" do
          let(:max) { random_integer }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end
      end

      context "with min" do
        let(:min) { random_integer }

        context "without max" do
          let(:max) { nil }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end

        context "when max is less than min" do
          let(:max) { min - 1 }

          it "is invalid" do
            record.valid?

            expect(record.errors.where(:max, :greater_than_or_equal_to, count: min)).not_to be_empty
          end
        end

        context "when max is equal to min" do
          let(:max) { min }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end

        context "when max is greater than min" do
          let(:max) { min + 1 }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
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
      include_examples "field_value_add", factory
      include_examples "field_value_add", factory, :with_min
      include_examples "field_value_add", factory, :with_max
      include_examples "field_value_add", factory, :with_min, :with_max
      include_examples "field_value_add", factory, :required
      include_examples "field_value_add", factory, :required, :with_min
      include_examples "field_value_add", factory, :required, :with_max
      include_examples "field_value_add", factory, :required, :with_min, :with_max
    end
  end
end
