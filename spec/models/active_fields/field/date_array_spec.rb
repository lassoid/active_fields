# frozen_string_literal: true

RSpec.describe ActiveFields::Field::DateArray do
  factory = :date_array_active_field

  it_behaves_like "active_field",
    factory: factory,
    available_traits: %i[with_min with_max with_min_size with_max_size]

  it_behaves_like "store_attribute_integer", :min_size, :options, described_class
  it_behaves_like "store_attribute_integer", :max_size, :options, described_class
  it_behaves_like "store_attribute_date", :min, :options, described_class
  it_behaves_like "store_attribute_date", :max, :options, described_class

  context "validations" do
    it_behaves_like "field_sizes_validate", factory: factory

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
end
