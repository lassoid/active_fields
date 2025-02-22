# frozen_string_literal: true

RSpec.describe Post do
  include_examples "customizable"

  context "methods" do
    describe "##allowed_active_fields_type_names" do
      subject(:call_method) { described_class.allowed_active_fields_type_names }

      it "contains only provided field types" do
        expect(call_method).to eq(%i[boolean date_array decimal ip ip_array])
      end
    end

    describe "##allowed_active_fields_class_names" do
      subject(:call_method) { described_class.allowed_active_fields_class_names }

      it "contains only provided field class names" do
        expect(call_method).to eq(ActiveFields.config.fields.values_at(*%i[boolean date_array decimal ip ip_array]))
      end
    end
  end
end
