# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Boolean do
  factory = :boolean_active_field

  it_behaves_like "active_field",
    factory: factory,
    available_traits: %i[required nullable]

  it_behaves_like "store_attribute_boolean", :required, :options, described_class
  it_behaves_like "store_attribute_boolean", :nullable, :options, described_class

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
  end
end
