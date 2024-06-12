# frozen_string_literal: true

RSpec.describe ActiveFields::CustomizableConfig do
  let(:object) { described_class.new(dummy_models.sample) }

  describe "types=" do
    subject(:call_method) { object.types = value }

    context "with valid elements provided" do
      let(:value) { ActiveFields.config.fields.keys.sample(rand(1..ActiveFields.config.fields.keys.size)) }

      it "sets types" do
        call_method

        expect(object.types).to eq(value)
      end
    end

    context "with invalid elements provided" do
      let(:value) { [ActiveFields.config.fields.keys.sample, :invalid] }

      it "raises an error" do
        expect do
          call_method
        end.to raise_error(ArgumentError)
      end
    end
  end
end
