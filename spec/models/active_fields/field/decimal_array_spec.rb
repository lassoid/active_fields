# frozen_string_literal: true

RSpec.describe ActiveFields::Field::DecimalArray do
  factory = :decimal_array_active_field

  it_behaves_like "active_field",
    factory: factory,
    available_traits: %i[with_min with_max with_min_size with_max_size]

  include_examples "store_attribute_integer", :min_size, :options, described_class
  include_examples "store_attribute_integer", :max_size, :options, described_class
  include_examples "store_attribute_decimal", :min, :options, described_class
  include_examples "store_attribute_decimal", :max, :options, described_class

  it "has a valid factory" do
    expect(build(factory)).to be_valid
  end

  context "validations" do
    include_examples "field_sizes_validate", factory: factory

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
          let(:max) { min + 0.1 }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max)).to be_empty
          end
        end
      end
    end
  end
end
