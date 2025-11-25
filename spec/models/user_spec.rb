# frozen_string_literal: true

RSpec.describe User do
  it_behaves_like "scoped_customizable"

  context "methods" do
    let(:record) { described_class.new }

    describe "##allowed_active_fields_type_names" do
      subject(:call_method) { described_class.allowed_active_fields_type_names }

      it "contains all field types" do
        expect(call_method).to eq(ActiveFields.config.type_names)
      end
    end

    describe "##allowed_active_fields_class_names" do
      subject(:call_method) { described_class.allowed_active_fields_class_names }

      it "contains all field class names" do
        expect(call_method).to eq(ActiveFields.config.type_class_names)
      end
    end

    describe "##active_fields_scope_method" do
      subject(:call_method) { described_class.active_fields_scope_method }

      it { is_expected.to eq(:tenant_id) }
    end

    describe "##active_fields_scope" do
      subject(:call_method) { record.active_fields_scope }

      before do
        record.tenant_id = random_string
      end

      it { is_expected.to eq(record.tenant_id) }
    end
  end
end
