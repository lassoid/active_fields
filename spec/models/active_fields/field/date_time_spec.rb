# frozen_string_literal: true

RSpec.describe ActiveFields::Field::DateTime do
  factory = :datetime_active_field

  it_behaves_like "active_field",
    factory: factory,
    available_traits: %i[required with_min with_max with_precision]

  include_examples "store_attribute_boolean", :required, :options, described_class
  include_examples "store_attribute_datetime", :min, :options, described_class
  include_examples "store_attribute_datetime", :max, :options, described_class
  include_examples "store_attribute_integer", :precision, :options, described_class

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
          let(:max) { random_datetime }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end
      end

      context "with min" do
        let(:min) { random_datetime }

        context "without max" do
          let(:max) { nil }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end

        context "when max is less than min" do
          let(:max) { min - 1.second }

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
          let(:max) { min + 1.second }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end
      end
    end

    describe "#precision" do
      let(:record) { build(factory, precision: precision) }

      context "without precision" do
        let(:precision) { nil }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:precision)).to be_empty
        end
      end

      context "when precision is negative" do
        let(:precision) { rand(-10..-1) }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:precision, :greater_than_or_equal_to, count: 0)).not_to be_empty
        end
      end

      context "when precision is zero" do
        let(:precision) { 0 }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:precision)).to be_empty
        end
      end

      context "when precision is positive" do
        let(:precision) { rand(1..10) }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:precision)).to be_empty
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
