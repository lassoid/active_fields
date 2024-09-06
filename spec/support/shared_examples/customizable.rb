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
      let!(:active_field) do
        create(active_field_factories_for(described_class).sample, customizable_type: described_class.name)
      end

      before do
        record.active_values_attributes = [attributes]
      end

      context "create" do
        let(:attributes) { { active_field_id: active_field.id, value: active_value_for(active_field) } }

        it "builds an active_value" do
          expect do
            save_record
            record.reload
          end.to change { record.active_values.count }.by(1)

          active_value = record.active_values.find { _1.active_field_id == active_field.id }
          expect(active_value.value).to eq(attributes[:value])
        end
      end

      context "update" do
        let!(:active_value) { create(active_value_factory, active_field: active_field, customizable: record) }
        let(:attributes) { { id: active_value.id, value: active_value_for(active_field) } }

        it "updates the active_value" do
          expect do
            save_record
            record.reload
            active_value.reload
          end.to not_change { record.active_values.count }

          expect(active_value.value).to eq(attributes[:value])
        end
      end

      context "destroy" do
        let!(:active_value) { create(active_value_factory, active_field: active_field, customizable: record) }
        let(:attributes) { { id: active_value.id, _destroy: true } }

        it "destroys the active_value" do
          expect do
            save_record
            record.reload
          end.to change { record.active_values.count }.by(-1)

          expect(record.active_values.find { _1.id == active_value.id }).to be_nil
        end
      end
    end
  end

  context "methods" do
    describe "#active_fields" do
      subject(:call_method) { record.active_fields }

      let(:record) { described_class.create! }

      let!(:active_fields) do
        dummy_models.map do |model|
          active_field_factories_for(model).map do |active_field_factory|
            create(active_field_factory, customizable_type: model.name)
          end
        end.flatten
      end

      it "returns active_fields for provided model only" do
        expect(call_method.to_a)
          .to include(*active_fields.select { |field| field.customizable_type == described_class.name })
          .and exclude(*active_fields.reject { |field| field.customizable_type == described_class.name })
      end
    end

    describe "#active_fields=" do
      subject(:call_method) { record.active_fields = [attributes] }

      let(:record) { described_class.create! }
      let!(:active_field) do
        create(active_field_factories_for(described_class).sample, customizable_type: described_class.name)
      end

      context "when active_value not found" do
        context "with value" do
          context "with hash containing symbol keys" do
            let(:attributes) { { name: active_field.name, value: active_value_for(active_field) } }

            it "builds an active_value" do
              expect do
                call_method
              end.to change { record.active_values.size }.by(1)

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes[:value])
            end
          end

          context "with hash containing string keys" do
            let(:attributes) { { "name" => active_field.name, "value" => active_value_for(active_field) } }

            it "builds an active_value" do
              expect do
                call_method
              end.to change { record.active_values.size }.by(1)

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes["value"])
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new(
                "name" => active_field.name,
                "value" => active_value_for(active_field),
              ).permit!
            end

            it "builds an active_value" do
              expect do
                call_method
              end.to change { record.active_values.size }.by(1)

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes[:value])
            end
          end

          context "with unpermitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => active_field.name, "value" => active_value_for(active_field))
            end

            it "raises an error" do
              expect do
                call_method
              end.to raise_error(ActionController::UnfilteredParameters)
            end
          end
        end

        context "with destroy mark" do
          context "with hash containing symbol keys" do
            let(:attributes) { { name: active_field.name, _destroy: true } }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with hash containing string keys" do
            let(:attributes) { { "name" => active_field.name, "_destroy" => true } }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => active_field.name, "_destroy" => "true").permit!
            end

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with unpermitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => active_field.name, "_destroy" => "true")
            end

            it "raises an error" do
              expect do
                call_method
              end.to raise_error(ActionController::UnfilteredParameters)
            end
          end
        end
      end

      context "when active_value found" do
        before do
          create(active_value_factory, active_field: active_field, customizable: record)
        end

        context "with value" do
          context "with hash containing symbol keys" do
            let(:attributes) { { name: active_field.name, value: active_value_for(active_field) } }

            it "changes the active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes[:value])
            end
          end

          context "with hash containing string keys" do
            let(:attributes) { { "name" => active_field.name, "value" => active_value_for(active_field) } }

            it "changes the active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes["value"])
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new(
                "name" => active_field.name,
                "value" => active_value_for(active_field),
              ).permit!
            end

            it "changes the active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes[:value])
            end
          end

          context "with unpermitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => active_field.name, "value" => active_value_for(active_field))
            end

            it "raises an error" do
              expect do
                call_method
              end.to raise_error(ActionController::UnfilteredParameters)
            end
          end
        end

        context "with destroy mark" do
          context "with hash containing symbol keys" do
            let(:attributes) { { name: active_field.name, _destroy: true } }

            it "marks the active_value for destruction" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.marked_for_destruction?).to be(true)
            end
          end

          context "with hash containing string keys" do
            let(:attributes) { { "name" => active_field.name, "_destroy" => true } }

            it "marks the active_value for destruction" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.marked_for_destruction?).to be(true)
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => active_field.name, "_destroy" => "true").permit!
            end

            it "marks the active_value for destruction" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.marked_for_destruction?).to be(true)
            end
          end

          context "with unpermitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => active_field.name, "_destroy" => "true")
            end

            it "raises an error" do
              expect do
                call_method
              end.to raise_error(ActionController::UnfilteredParameters)
            end
          end
        end
      end

      context "when active_field not found" do
        context "with value" do
          context "with hash containing symbol keys" do
            let(:attributes) { { name: "invalid", value: nil } }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with hash containing string keys" do
            let(:attributes) { { "name" => "invalid", "value" => nil } }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => "invalid", "value" => nil).permit!
            end

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with unpermitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => "invalid", "value" => nil)
            end

            it "raises an error" do
              expect do
                call_method
              end.to raise_error(ActionController::UnfilteredParameters)
            end
          end
        end

        context "with destroy mark" do
          context "with hash containing symbol keys" do
            let(:attributes) { { name: "invalid", _destroy: true } }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with hash containing string keys" do
            let(:attributes) { { "name" => "invalid", "_destroy" => true } }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => "invalid", "_destroy" => "true").permit!
            end

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with unpermitted params" do
            let(:attributes) do
              ActionController::Parameters.new("name" => "invalid", "_destroy" => "true")
            end

            it "raises an error" do
              expect do
                call_method
              end.to raise_error(ActionController::UnfilteredParameters)
            end
          end
        end
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
