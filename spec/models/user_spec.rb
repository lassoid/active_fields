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
        record.tenant_id = value
      end

      context "when value is nil" do
        let(:value) { nil }

        it { is_expected.to be_nil }
      end

      context "when value is not nil" do
        let(:value) { random_integer }

        it { is_expected.to eq(value.to_s) }
      end
    end
  end

  context "callbacks" do
    describe "after_update #clear_unavailable_active_values" do
      let!(:global_active_field) do
        create(
          active_field_factories_for(described_class).sample,
          customizable_type: described_class.name,
          scope: nil,
        )
      end
      let!(:scoped_active_field) do
        create(
          active_field_factories_for(described_class).sample,
          customizable_type: described_class.name,
          scope: "scope",
        )
      end
      let!(:other_scope_active_field) do
        create(
          active_field_factories_for(described_class).sample,
          customizable_type: described_class.name,
          scope: "other_scope",
        )
      end
      let!(:record) do
        described_class.create!(
          tenant_id: scoped_active_field.scope,
          active_values_attributes: [
            {
              active_field_id: global_active_field.id,
              value: active_value_for(global_active_field),
            },
            {
              active_field_id: scoped_active_field.id,
              value: active_value_for(scoped_active_field),
            },
          ],
        )
      end

      context "when tenant_id was changed" do
        let(:new_scope) { other_scope_active_field.scope }

        it "destroys orphaned active_values" do
          record.update!(tenant_id: new_scope)

          expect(record.active_values.find_by(active_field_id: scoped_active_field.id)).to be_nil
          expect(record.active_values.find_by(active_field_id: global_active_field.id)).not_to be_nil
        end

        it "allows active_values for new scope to be created" do
          record.update!(
            tenant_id: new_scope,
            active_values_attributes: [
              {
                active_field_id: other_scope_active_field.id,
                value: active_value_for(other_scope_active_field),
              },
            ],
          )

          expect(record.active_values.find_by(active_field_id: other_scope_active_field.id)).not_to be_nil
        end
      end

      context "when tenant_id was not changed" do
        let(:new_scope) { record.tenant_id }

        it "does not destroy any active_value" do
          expect do
            record.update!(tenant_id: new_scope)
          end.to not_change(record.active_values, :count)
        end
      end
    end
  end
end
