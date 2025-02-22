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

  context "scopes" do
    describe "#where_active_fields" do
      subject(:call_scope) { described_class.where_active_fields(args).to_a }

      def search_op(active_field) = "operator_#{active_field.id}"
      def search_value(active_field) = "value_#{active_field.id}"

      let!(:active_fields) do
        (active_field_factories_for(described_class) - [:ip_array_field]).sample(2).map do |active_field_factory|
          create(active_field_factory, customizable_type: described_class.name)
        end
      end

      let!(:records) do
        Array.new(3) do
          described_class.create!(
            active_fields_attributes: active_fields.map do |active_field|
              { name: active_field.name, value: active_value_for(active_field) }
            end,
          )
        end
      end

      let(:mapping) do
        active_fields.map { |active_field| [active_field.id, records.sample(2).map(&:id)] }.to_h
      end

      before do
        active_fields.each do |active_field|
          finder = instance_double(active_field.value_finder_class)
          allow(active_field.value_finder_class).to receive(:new).and_return(finder)

          allow(finder).to receive(:search).with(
            op: search_op(active_field),
            value: search_value(active_field),
          ).and_return(
            active_field.active_values.where(customizable_id: mapping[active_field.id]),
          )
        end
      end

      context "with array of symbol hashes" do
        let(:args) do
          active_fields.map do |active_field|
            {
              name: active_field.name,
              operator: search_op(active_field),
              value: search_value(active_field),
            }
          end
        end

        it "returns records with matching active_values" do
          expect(call_scope)
            .to include(*described_class.where(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
            .and exclude(*described_class.where.not(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
        end
      end

      context "with array of string hashes" do
        let(:args) do
          active_fields.map do |active_field|
            {
              "name" => active_field.name,
              "operator" => search_op(active_field),
              "value" => search_value(active_field),
            }
          end
        end

        it "returns records with matching active_values" do
          expect(call_scope)
            .to include(*described_class.where(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
            .and exclude(*described_class.where.not(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
        end
      end

      context "with array of compact keys hashes" do
        let(:args) do
          active_fields.map do |active_field|
            {
              n: active_field.name,
              op: search_op(active_field),
              v: search_value(active_field),
            }
          end
        end

        it "returns records with matching active_values" do
          expect(call_scope)
            .to include(*described_class.where(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
            .and exclude(*described_class.where.not(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
        end
      end

      context "with permitted params hash" do
        let(:args) do
          ActionController::Parameters.new(
            active_fields.map.with_index(0) do |active_field, i|
              [
                i.to_s,
                {
                  name: active_field.name,
                  operator: search_op(active_field),
                  value: search_value(active_field),
                },
              ]
            end.to_h,
          ).permit!
        end

        it "returns records with matching active_values" do
          expect(call_scope)
            .to include(*described_class.where(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
            .and exclude(*described_class.where.not(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
        end
      end

      context "with permitted params compact keys hash" do
        let(:args) do
          ActionController::Parameters.new(
            active_fields.map.with_index(0) do |active_field, i|
              [
                i.to_s,
                {
                  n: active_field.name,
                  op: search_op(active_field),
                  v: search_value(active_field),
                },
              ]
            end.to_h,
          ).permit!
        end

        it "returns records with matching active_values" do
          expect(call_scope)
            .to include(*described_class.where(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
            .and exclude(*described_class.where.not(id: active_fields.map { mapping[_1.id] }.inject(&:&)).to_a)
        end
      end

      context "with hash unpermitted params" do
        let(:args) do
          ActionController::Parameters.new(
            active_fields.map.with_index(0) do |active_field, i|
              [
                i.to_s,
                {
                  name: active_field.name,
                  operator: search_op(active_field),
                  value: search_value(active_field),
                },
              ]
            end.to_h,
          )
        end

        it "raises an error" do
          expect do
            call_scope
          end.to raise_error(ActionController::UnfilteredParameters)
        end
      end

      context "with invalid active_field name" do
        let(:args) do
          [{
            name: "not_exist",
            operator: "operator",
            value: "value",
          }]
        end

        it "skips search and returns all customizables" do
          expect(call_scope).to include(*described_class.all.to_a)
        end
      end

      context "with active_field without finder" do
        let!(:active_field_without_finder) { create(:ip_array_field, customizable_type: described_class.name) }

        let(:args) do
          [{
            name: active_field_without_finder.name,
            operator: "operator",
            value: "value",
          }]
        end

        it "skips search and returns all customizables" do
          expect(call_scope).to include(*described_class.all.to_a)
        end
      end

      context "with neither a params nor a hash nor an array" do
        let(:args) { "invalid" }

        it "raises an error" do
          expect do
            call_scope
          end.to raise_error(ArgumentError)
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

      context "with a new active_value" do
        let(:attributes) { { active_field_id: active_field.id, value: active_value_for(active_field) } }

        it "creates it" do
          expect do
            save_record
            record.reload
          end.to change { record.active_values.count }.by(1)

          active_value = record.active_values.find { _1.active_field_id == active_field.id }
          expect(active_value.value).to eq(attributes[:value])
        end
      end

      context "with a persisted active_value" do
        let!(:active_value) { create(active_value_factory, active_field: active_field, customizable: record) }
        let(:attributes) { { id: active_value.id, value: active_value_for(active_field) } }

        it "updates it if changed" do
          expect do
            save_record
            record.reload
            active_value.reload
          end.to not_change { record.active_values.count }

          expect(active_value.value).to eq(attributes[:value])
        end
      end

      context "with a persisted active_value marked for destruction" do
        let!(:active_value) { create(active_value_factory, active_field: active_field, customizable: record) }
        let(:attributes) { { id: active_value.id, _destroy: true } }

        it "destroys it" do
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
    describe "##active_fields" do
      subject(:call_method) { described_class.active_fields }

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

    describe "#active_fields_attributes=" do
      subject(:call_method) { record.active_fields_attributes = attributes }

      let(:record) { described_class.create! }
      let!(:active_field) do
        create(active_field_factories_for(described_class).sample, customizable_type: described_class.name)
      end

      context "when active_value not found" do
        context "with value" do
          context "with array of symbol hashes" do
            let(:attributes) { [{ name: active_field.name, value: active_value_for(active_field) }] }

            it "builds an active_value" do
              expect do
                call_method
              end.to change { record.active_values.size }.by(1)

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes.first[:value])
            end
          end

          context "with array of string hashes" do
            let(:attributes) { [{ "name" => active_field.name, "value" => active_value_for(active_field) }] }

            it "builds an active_value" do
              expect do
                call_method
              end.to change { record.active_values.size }.by(1)

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes.first["value"])
            end
          end

          context "with array of permitted params" do
            let(:attributes) do
              [
                ActionController::Parameters.new(
                  "name" => active_field.name,
                  "value" => active_value_for(active_field),
                ).permit!,
              ]
            end

            it "builds an active_value" do
              expect do
                call_method
              end.to change { record.active_values.size }.by(1)

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes.first[:value])
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new(
                "0" => { "name" => active_field.name, "value" => active_value_for(active_field) },
              ).permit!
            end

            it "builds an active_value" do
              expect do
                call_method
              end.to change { record.active_values.size }.by(1)

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes.values.first[:value])
            end
          end
        end

        context "with destroy mark" do
          context "with array of symbol hashes" do
            let(:attributes) { [{ name: active_field.name, _destroy: true }] }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with array of string hashes" do
            let(:attributes) { [{ "name" => active_field.name, "_destroy" => true }] }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with array of permitted params" do
            let(:attributes) do
              [ActionController::Parameters.new("name" => active_field.name, "_destroy" => "true").permit!]
            end

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new(
                "0" => { "name" => active_field.name, "_destroy" => "true" },
              ).permit!
            end

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end
        end
      end

      context "when active_value found" do
        before do
          create(active_value_factory, active_field: active_field, customizable: record)
        end

        context "with value" do
          context "with array of symbol hashes" do
            let(:attributes) { [{ name: active_field.name, value: active_value_for(active_field) }] }

            it "changes the active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes.first[:value])
            end
          end

          context "with array of string hashes" do
            let(:attributes) { [{ "name" => active_field.name, "value" => active_value_for(active_field) }] }

            it "changes the active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes.first["value"])
            end
          end

          context "with array of permitted params" do
            let(:attributes) do
              [
                ActionController::Parameters.new(
                  "name" => active_field.name,
                  "value" => active_value_for(active_field),
                ).permit!,
              ]
            end

            it "changes the active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes.first[:value])
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new(
                "0" => { "name" => active_field.name, "value" => active_value_for(active_field) },
              ).permit!
            end

            it "changes the active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.value).to eq(attributes.values.first[:value])
            end
          end
        end

        context "with destroy mark" do
          context "with array of symbol hashes" do
            let(:attributes) { [{ name: active_field.name, _destroy: true }] }

            it "marks the active_value for destruction" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.marked_for_destruction?).to be(true)
            end
          end

          context "with array of string hashes" do
            let(:attributes) { [{ "name" => active_field.name, "_destroy" => true }] }

            it "marks the active_value for destruction" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.marked_for_destruction?).to be(true)
            end
          end

          context "with array of permitted params" do
            let(:attributes) do
              [ActionController::Parameters.new("name" => active_field.name, "_destroy" => "true").permit!]
            end

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
              ActionController::Parameters.new(
                "0" => { "name" => active_field.name, "_destroy" => "true" },
              ).permit!
            end

            it "marks the active_value for destruction" do
              expect do
                call_method
              end.to not_change { record.active_values.size }

              active_value = record.active_values.find { _1.active_field_id == active_field.id }
              expect(active_value.marked_for_destruction?).to be(true)
            end
          end
        end
      end

      context "when active_field not found" do
        context "with value" do
          context "with array of symbol hashes" do
            let(:attributes) { [{ name: "invalid", value: nil }] }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with array of string hashes" do
            let(:attributes) { [{ "name" => "invalid", "value" => nil }] }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with array of permitted params" do
            let(:attributes) do
              [ActionController::Parameters.new("name" => "invalid", "value" => nil).permit!]
            end

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new(
                "0" => { "name" => "invalid", "value" => nil },
              ).permit!
            end

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end
        end

        context "with destroy mark" do
          context "with array of symbol hashes" do
            let(:attributes) { [{ name: "invalid", _destroy: true }] }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with array of string hashes" do
            let(:attributes) { [{ "name" => "invalid", "_destroy" => true }] }

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with array of permitted params" do
            let(:attributes) do
              [ActionController::Parameters.new("name" => "invalid", "_destroy" => "true").permit!]
            end

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end

          context "with permitted params" do
            let(:attributes) do
              ActionController::Parameters.new(
                "0" => { "name" => "invalid", "_destroy" => "true" },
              ).permit!
            end

            it "doesn't build an active_value" do
              expect do
                call_method
              end.to not_change { record.active_values.size }
            end
          end
        end
      end

      context "with neither a params nor a hash nor an array" do
        let(:attributes) { "invalid" }

        it "raises an error" do
          expect do
            call_method
          end.to raise_error(ArgumentError)
        end
      end

      context "with unpermitted params" do
        let(:attributes) do
          ActionController::Parameters.new("0" => { "name" => "name", "value" => "value" })
        end

        it "raises an error" do
          expect do
            call_method
          end.to raise_error(ActionController::UnfilteredParameters)
        end
      end

      context "with array of unpermitted params" do
        let(:attributes) do
          [ActionController::Parameters.new("name" => "name", "value" => "value")]
        end

        it "raises an error" do
          expect do
            call_method
          end.to raise_error(ActionController::UnfilteredParameters)
        end
      end
    end

    describe "#active_fields=" do
      let(:record) { described_class.new }

      it "is an alias of #active_fields_attributes=" do
        expect(record.method(:active_fields=)).to eq(record.method(:active_fields_attributes=))
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

      it "returns new active_values collection" do
        expect(call_method).to eq(record.active_values)
      end
    end
  end
end
