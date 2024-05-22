# frozen_string_literal: true

RSpec.describe ActiveFields::Field::TextArray do
  factory = :text_array_active_field

  it_behaves_like "active_field",
    factory: factory,
    available_traits: %i[with_min_length with_max_length with_min_size with_max_size]

  include_examples "store_attribute_integer", :min_size, :options, described_class
  include_examples "store_attribute_integer", :max_size, :options, described_class
  include_examples "store_attribute_integer", :min_length, :options, described_class
  include_examples "store_attribute_integer", :max_length, :options, described_class

  it "has a valid factory" do
    expect(build(factory)).to be_valid
  end

  context "validations" do
    include_examples "field_sizes_validate", factory: factory

    describe "#min_length" do
      let(:record) { build(factory, min_length: min_length) }

      context "without min_length" do
        let(:min_length) { nil }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:min_length)).to be_empty
        end
      end

      context "when min_length is negative" do
        let(:min_length) { rand(-10..-1) }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:min_length, :greater_than_or_equal_to, count: 0)).not_to be_empty
        end
      end

      context "when min_length is zero" do
        let(:min_length) { 0 }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:min_length)).to be_empty
        end
      end

      context "when min_length is positive" do
        let(:min_length) { rand(1..10) }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:min_length)).to be_empty
        end
      end
    end

    describe "#max_length" do
      let(:record) { build(factory, min_length: min_length, max_length: max_length) }

      context "without min_length" do
        let(:min_length) { nil }

        context "without max_length" do
          let(:max_length) { nil }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max_length)).to be_empty
          end
        end

        context "when max_length is negative" do
          let(:max_length) { rand(-10..-1) }

          it "is invalid" do
            record.valid?

            expect(record.errors.where(:max_length, :greater_than_or_equal_to, count: 0)).not_to be_empty
          end
        end

        context "when max_length is zero" do
          let(:max_length) { 0 }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max_length)).to be_empty
          end
        end

        context "when max_length is positive" do
          let(:max_length) { rand(1..10) }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max_length)).to be_empty
          end
        end
      end

      context "with min_length" do
        let(:min_length) { rand(1..10) }

        context "without max_length" do
          let(:max_length) { nil }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max_length)).to be_empty
          end
        end

        context "when max_length is less than min_length" do
          let(:max_length) { min_length - 1 }

          it "is invalid" do
            record.valid?

            expect(record.errors.where(:max_length, :greater_than_or_equal_to, count: min_length)).not_to be_empty
          end
        end

        context "when max_length is equal to min_length" do
          let(:max_length) { min_length }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max_length)).to be_empty
          end
        end

        context "when max_length is greater than min_length" do
          let(:max_length) { min_length + 1 }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:max_length)).to be_empty
          end
        end
      end
    end
  end
end
