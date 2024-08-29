# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Date do
  factory = :date_active_field

  it_behaves_like "active_field",
    factory: factory,
    available_traits: %i[required with_min with_max]

  include_examples "store_attribute_boolean", :required, :options, described_class
  include_examples "store_attribute_date", :min, :options, described_class
  include_examples "store_attribute_date", :max, :options, described_class

  context "validations" do
    describe "#max" do
      let(:record) { build(factory, min: min, max: max) }

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
          let(:max) { random_date }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end
      end

      context "with min" do
        let(:min) { random_date }

        context "without max" do
          let(:max) { nil }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end

        context "when max is less than min" do
          let(:max) { min - 1.day }

          it "is invalid" do
            record.valid?

            expect(record.errors.where(:max, :greater_than_or_equal_to, count: record.min)).not_to be_empty
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
          let(:max) { min + 1.day }

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
  end
end
