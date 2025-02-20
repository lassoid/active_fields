# frozen_string_literal: true

RSpec.describe ActiveFields::CustomizableConfig do
  let(:object) { described_class.new(dummy_models.sample.name) }

  describe "types=" do
    subject(:call_method) { object.types = value }

    context "with valid elements provided" do
      let(:value) { ActiveFields.config.type_names.sample(rand(1..ActiveFields.config.type_names.size)) }

      it "sets types" do
        call_method

        expect(object.types).to eq(value)
      end
    end

    context "with invalid elements provided" do
      let(:value) { [ActiveFields.config.type_names.sample, :invalid] }

      it "raises an error" do
        expect do
          call_method
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe "#types_class_names" do
    subject(:call_method) { object.types_class_names }

    before do
      object.types = ActiveFields.config.type_names.sample(rand(1..ActiveFields.config.type_names.size))
    end

    it "returns class names for configured types" do
      expect(call_method).to eq(ActiveFields.config.fields.values_at(*object.types))
    end
  end
end
