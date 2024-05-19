# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Text do
  factory = :text_active_field

  it_behaves_like "active_field", factory: factory

  include_examples "store_attribute_boolean", :required, :options, described_class
  include_examples "store_attribute_integer", :min_length, :options, described_class
  include_examples "store_attribute_integer", :max_length, :options, described_class

  it "has a valid factory" do
    expect(build(factory)).to be_valid
  end

  context "validations" do
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
      include_examples "field_value_add", factory, :with_min_length
      include_examples "field_value_add", factory, :with_max_length
      include_examples "field_value_add", factory, :with_min_length, :with_max_length
      include_examples "field_value_add", factory, :required
      include_examples "field_value_add", factory, :required, :with_min_length
      include_examples "field_value_add", factory, :required, :with_max_length
      include_examples "field_value_add", factory, :required, :with_min_length, :with_max_length
    end
  end
end
