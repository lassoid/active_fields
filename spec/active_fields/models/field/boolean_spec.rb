# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Boolean do
  it_behaves_like "active_field", factory: :boolean_active_field

  include_examples "store_attribute_boolean", :required, :options, described_class
  include_examples "store_attribute_boolean", :nullable, :options, described_class

  it "has a valid factory" do
    expect(build(:boolean_active_field)).to be_valid
  end

  context "callbacks" do
    describe "after_initialize #set_defaults" do
      let(:record) { described_class.new(required: required, nullable: nullable) }
      let(:required) { nil }
      let(:nullable) { nil }

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

      context "when nullable is nil" do
        it "sets false" do
          expect(record.nullable).to be(false)
        end
      end

      context "when nullable is not nil" do
        let(:nullable) { [true, false].sample }

        it "doesn't change column" do
          expect(record.nullable).to be(nullable)
        end
      end
    end

    describe "after_create #add_field_to_records" do
      include_examples "field_value_add", :boolean_active_field
      include_examples "field_value_add", :boolean_active_field, :nullable
      include_examples "field_value_add", :boolean_active_field, :required
      include_examples "field_value_add", :boolean_active_field, :required, :nullable
    end
  end
end
