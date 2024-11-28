# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Decimal do
  factory = :decimal_active_field

  it_behaves_like "active_field",
    factory: factory,
    available_traits: %i[required with_min with_max with_precision]

  include_examples "store_attribute_boolean", :required, :options, described_class
  include_examples "store_attribute_decimal", :min, :options, described_class
  include_examples "store_attribute_decimal", :max, :options, described_class
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
          let(:max) { random_decimal }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end
      end

      context "with min" do
        let(:min) { random_decimal }

        context "without max" do
          let(:max) { nil }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end

        context "when max is less than min" do
          let(:max) { min - 0.1 }

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
          let(:max) { min + 0.1 }

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

      context "when precision is less than max allowed" do
        let(:precision) { ActiveFields::MAX_DECIMAL_PRECISION - 1 }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:precision)).to be_empty
        end
      end

      context "when precision is max allowed" do
        let(:precision) { ActiveFields::MAX_DECIMAL_PRECISION }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:precision)).to be_empty
        end
      end

      context "when precision is greater than max allowed" do
        let(:precision) { ActiveFields::MAX_DECIMAL_PRECISION + 1 }

        it "is invalid" do
          record.valid?

          errors = record.errors.where(
            :precision,
            :less_than_or_equal_to,
            count: ActiveFields::MAX_DECIMAL_PRECISION,
          )
          expect(errors).not_to be_empty
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

    describe "before_save #reapply_precision" do
      max_precision = ActiveFields::MAX_DECIMAL_PRECISION
      let(:record) { build(factory) }
      let(:precision) { rand(0..(max_precision - 1)) }
      let(:attrs) do
        {
          # Ensure that values do not end with a 0 to prevent truncation of leading zeros
          min: [rand(-10..-2), Array.new(max_precision) { rand(1..9) }.join].join("."),
          max: [rand(2..10), Array.new(max_precision) { rand(1..9) }.join].join("."),
          default_value: [rand(-1..1), Array.new(max_precision) { rand(1..9) }.join].join("."),
        }
      end

      before do
        # Reassign attributes autogenerated by factory
        record.assign_attributes(attrs)
        # Set precision after assigning other attributes to ensure that
        # attribute setters do not have access to the precision
        record.precision = precision
      end

      it "reapplies precision before save" do
        expect do
          record.save!
        end.to change { record.options["min"] }
          .from(attrs[:min]).to(BigDecimal(attrs[:min]).truncate(precision).to_s)
          .and change { record.options["max"] }
          .from(attrs[:max]).to(BigDecimal(attrs[:max]).truncate(precision).to_s)
          .and change { record.default_value_meta["const"] }
          .from(attrs[:default_value]).to(BigDecimal(attrs[:default_value]).truncate(precision).to_s)
      end
    end
  end
end
