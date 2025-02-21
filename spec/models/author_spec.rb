# frozen_string_literal: true

RSpec.describe Author do
  include_examples "customizable"

  context "methods" do
    describe "##allowed_field_type_names" do
      subject(:call_method) { described_class.allowed_field_type_names }

      it "contains all field types" do
        expect(call_method).to eq(ActiveFields.config.type_names)
      end
    end

    describe "##allowed_field_class_names" do
      subject(:call_method) { described_class.allowed_field_class_names }

      it "contains all field class names" do
        expect(call_method).to eq(ActiveFields.config.type_class_names)
      end
    end
  end
end
