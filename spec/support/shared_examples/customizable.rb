# frozen_string_literal: true

RSpec.shared_examples "customizable" do
  it "is a customizable" do
    expect(described_class.ancestors).to include(ActiveFields::CustomizableConcern)
  end

  context "validations" do
    describe "#active_values" do
      let!(:active_field) do
        create(active_field_factories_for(described_class).sample, customizable_type: described_class.name)
      end
      let(:value) { active_value_for(active_field) }
      let(:value_errors) { Set.new([:invalid, [:greater_than, count: random_number]]) }

      before do
        validator = instance_double(active_field.value_validator_class, errors: value_errors)
        allow(active_field.value_validator_class).to receive(:new).and_return(validator)
        allow(validator).to receive(:validate).with(value).and_return(value_errors.empty?)

        record.active_values_attributes = [{ active_field_id: active_field.id, value: value }]
      end

      context "new record" do
        let(:record) { described_class.new }

        it "validates" do
          record.valid?

          active_value = record.active_values.find { |active_value| active_value.active_field_id == active_field.id }

          value_errors.each do |error|
            expect(record.errors.added?(:"active_values.value", *error)).to be(true)
            expect(active_value.errors.added?(:value, *error)).to be(true)
          end
        end
      end

      context "persisted record" do
        let!(:record) { described_class.create! }

        it "validates" do
          record.valid?

          active_value = record.active_values.find { |active_value| active_value.active_field_id == active_field.id }

          value_errors.each do |error|
            expect(record.errors.added?(:"active_values.value", *error)).to be(true)
            expect(active_value.errors.added?(:value, *error)).to be(true)
          end
        end
      end
    end
  end

  context "callbacks" do
    describe "active_fields nested attributes autosave" do
      subject(:save_record) { record.save! }

      let!(:record) { described_class.create! }
      let!(:active_fields) do
        active_field_factories_for(record.class).map do |active_field_factory|
          create(active_field_factory, customizable_type: record.class.name)
        end
      end
      let!(:existing_active_values) do
        active_fields.sample(3).map do |active_field|
          create(active_value_factory, active_field: active_field, customizable: record)
        end
      end
      let(:data) do
        {
          active_field_to_create: active_fields.find { existing_active_values.map(&:active_field_id).exclude?(_1.id) },
          active_value_to_update: existing_active_values.first,
          active_value_to_destroy: existing_active_values.second,
          unchanged_active_value: existing_active_values.third,
        }
      end
      let(:action_attributes) do
        {
          create: {
            active_field_id: data[:active_field_to_create].id,
            value: active_value_for(data[:active_field_to_create]),
          },
          update: {
            id: data[:active_value_to_update].id,
            value: active_value_for(data[:active_value_to_update].active_field),
          },
          destroy: {
            id: data[:active_value_to_destroy].id,
            _destroy: true,
          },
        }
      end

      before do
        record.active_values_attributes = action_attributes.values
      end

      it "creates new active_values" do
        save_record
        record.reload

        created_active_value = record.active_values.find { _1.active_field_id == data[:active_field_to_create].id }
        expect(created_active_value.value).to eq(action_attributes[:create][:value])
      end

      it "updates active_values" do
        save_record
        data[:active_value_to_update].reload

        expect(data[:active_value_to_update].value).to eq(action_attributes[:update][:value])
      end

      it "destroys active_values" do
        save_record
        record.reload

        destroyed_active_value = record.active_values.find { _1.id == data[:active_value_to_destroy].id }
        expect(destroyed_active_value).to be_nil
      end

      it "doesn't change other active_values" do
        expect do
          save_record
          data[:unchanged_active_value].reload
        end.to not_change { data[:unchanged_active_value].value }
      end
    end
  end

  context "methods" do
    describe "#active_fields" do
      let(:record) { described_class.create! }

      let!(:active_fields) do
        dummy_models.map do |model|
          active_field_factories_for(model).map do |active_field_factory|
            create(active_field_factory, customizable_type: model.name)
          end
        end.flatten
      end

      it "returns active_fields for provided model only" do
        expect(record.active_fields.to_a)
          .to include(*active_fields.select { |field| field.customizable_type == described_class.name })
          .and exclude(*active_fields.reject { |field| field.customizable_type == described_class.name })
      end
    end

    describe "#initialize_active_values" do
      subject(:call_method) { record.initialize_active_values }

      let!(:record) { described_class.create! }
      let!(:active_fields) do
        active_field_factories_for(record.class).map do |active_field_factory|
          create(active_field_factory, customizable_type: record.class.name)
        end
      end
      let!(:existing_active_values) do
        active_fields.sample(rand(active_fields.size)).map do |active_field|
          create(active_value_factory, active_field: active_field, customizable: record)
        end
      end

      it "builds not existing active_values" do
        expect do
          call_method
        end.to change { record.active_values.size }.by(active_fields.size - existing_active_values.size)
      end

      it "doesn't save active_values that were built" do
        call_method

        new_active_values =
          record.active_values.reject { existing_active_values.map(&:active_field_id).include?(_1.active_field_id) }
        expect(new_active_values.map(&:persisted?).uniq).to eq([false])
      end

      it "sets default values" do
        call_method

        new_active_values =
          record.active_values.reject { existing_active_values.map(&:active_field_id).include?(_1.active_field_id) }
        expect(new_active_values.map(&:value)).to eq(new_active_values.map { _1.active_field.default_value })
      end
    end
  end
end
