# frozen_string_literal: true

RSpec.shared_examples "customizable" do
  context "validations" do
    describe "#active_values" do
      let!(:active_field) do
        active_field = build(:active_value).active_field
        active_field.update!(customizable_type: described_class.name)

        active_field
      end
      let(:value) { active_value_for(active_field) }
      let(:value_errors) { Set.new([:invalid, [:greater_than, count: random_number]]) }

      context "new record" do
        let(:record) { described_class.new(active_values_attributes: { active_field.name => value }) }

        before do
          validator = instance_double(active_field.value_validator_class, errors: value_errors)
          allow(active_field.value_validator_class).to receive(:new).and_return(validator)
          allow(validator).to receive(:validate).with(value).and_return(value_errors.empty?)
        end

        it "validates" do
          record.valid?

          active_value = record.active_values.find { |active_value| active_value.active_field_id == active_field.id }
          expect(record.errors.where(:active_values, :invalid)).not_to be_empty
          value_errors.each do |error|
            expect(active_value.errors.added?(:value, *error)).to be(true)
          end
        end
      end

      context "persisted record" do
        let!(:record) { described_class.create! }

        before do
          validator = instance_double(active_field.value_validator_class, errors: value_errors)
          allow(active_field.value_validator_class).to receive(:new).and_return(validator)
          allow(validator).to receive(:validate).with(value).and_return(value_errors.empty?)

          record.active_values_attributes = { active_field.name => value }
        end

        it "validates" do
          record.valid?

          active_value = record.active_values.find { |active_value| active_value.active_field_id == active_field.id }
          expect(record.errors.where(:active_values, :invalid)).not_to be_empty
          value_errors.each do |error|
            expect(active_value.errors.added?(:value, *error)).to be(true)
          end
        end
      end
    end
  end

  context "callbacks" do
    let!(:active_field) do
      active_field = build(:active_value).active_field
      active_field.update!(customizable_type: described_class.name)

      active_field
    end

    describe "before_validation #initialize_active_values" do
      context "new record" do
        let(:record) { described_class.new(active_values_attributes: active_values_attributes) }

        context "with nil active_values_attributes" do
          let(:active_values_attributes) { nil }

          it "builds active_values with defaults" do
            expect do
              record.valid?
            end.to change { record.active_values.size }.by(1)

            field = record.active_values.find { |active_value| active_value.active_field_id == active_field.id }
            expect(field.value).to eq(active_field.default_value)
          end
        end

        context "with invalid active_values_attributes" do
          let(:active_values_attributes) { random_string }

          it "builds active_values with defaults" do
            expect do
              record.valid?
            end.to change { record.active_values.size }.by(1)

            field = record.active_values.find { |active_value| active_value.active_field_id == active_field.id }
            expect(field.value).to eq(active_field.default_value)
          end
        end

        context "with string active_values_attributes keys" do
          let(:active_values_attributes) do
            {
              active_field.name => active_value_for(active_field),
              "non existing active_field name" => "doesn't matter",
            }
          end

          it "builds active_values with provided values" do
            expect do
              record.valid?
            end.to change { record.active_values.size }.by(1)

            field = record.active_values.find { |active_value| active_value.active_field_id == active_field.id }
            expect(field.value).to eq(active_values_attributes[active_field.name])
          end
        end

        context "with symbol active_values_attributes keys" do
          let(:active_values_attributes) do
            {
              active_field.name.to_sym => active_value_for(active_field),
              :"non existing active_field name" => "doesn't matter",
            }
          end

          it "builds active_values with provided values" do
            expect do
              record.valid?
            end.to change { record.active_values.size }.by(1)

            field = record.active_values.find { |active_value| active_value.active_field_id == active_field.id }
            expect(field.value).to eq(active_values_attributes[active_field.name.to_sym])
          end
        end
      end

      context "persisted record" do
        let!(:record) { described_class.create! }

        before do
          record.active_values_attributes = active_values_attributes
        end

        context "with nil active_values_attributes" do
          let(:active_values_attributes) { nil }

          it "doesn't change active_values values" do
            expect do
              record.valid?
            end.to not_change { record.active_values.find { _1.active_field_id == active_field.id }.value }
          end
        end

        context "with invalid active_values_attributes" do
          let(:active_values_attributes) { random_string }

          it "doesn't change active_values values" do
            expect do
              record.valid?
            end.to not_change { record.active_values.find { _1.active_field_id == active_field.id }.value }
          end
        end

        context "with string active_values_attributes keys" do
          let(:active_values_attributes) do
            {
              active_field.name => active_value_for(active_field),
              "non existing active_field name" => "doesn't matter",
            }
          end

          it "changes active_values for provided values only" do
            record.valid?

            active_value = record.active_values.find { _1.active_field_id == active_field.id }
            expect(active_value.value).to eq(active_values_attributes[active_field.name])
          end
        end

        context "with symbol active_values_attributes keys" do
          let(:active_values_attributes) do
            {
              active_field.name.to_sym => active_value_for(active_field),
              :"non existing active_field name" => "doesn't matter",
            }
          end

          it "changes active_values for provided values only" do
            record.valid?

            active_value = record.active_values.find { _1.active_field_id == active_field.id }
            expect(active_value.value).to eq(active_values_attributes[active_field.name.to_sym])
          end
        end
      end
    end

    describe "after_save #save_changed_active_values" do
      let!(:other_active_field) do
        active_field = build(:active_value).active_field
        active_field.update!(customizable_type: described_class.name)

        active_field
      end
      let(:active_values_attributes) do
        {
          active_field.name => active_value_for(active_field),
          "non existing active_field name" => "doesn't matter",
        }
      end

      before do
        record.active_values_attributes = active_values_attributes
      end

      context "new record" do
        let(:record) { described_class.new }

        it "saves active_values with provided values" do
          record.save!
          record.reload

          changed_value = record.active_values.find { _1.active_field_id == active_field.id }
          expect(changed_value.value).to eq(active_values_attributes[active_field.name])
        end

        it "saves active_values without provided values" do
          record.save!
          record.reload

          not_changed_value = record.active_values.find { _1.active_field_id == other_active_field.id }
          expect(not_changed_value.value).to eq(other_active_field.default_value)
        end
      end

      context "persisted record" do
        let!(:record) { described_class.create! }

        it "saves active_values with provided values" do
          record.save!
          record.reload

          changed_value = record.active_values.find { _1.active_field_id == active_field.id }
          expect(changed_value.value).to eq(active_values_attributes[active_field.name])
        end

        it "doesn't save active_values without provided values" do
          expect do
            record.save!
            record.reload
          end.to not_change { record.active_values.find { _1.active_field_id == other_active_field.id }.value }
        end
      end
    end
  end

  context "methods" do
    describe "#active_fields" do
      let(:record) { described_class.create! }

      let!(:active_fields) do
        author_active_field = build(:active_value).active_field.tap { _1.update!(customizable_type: "Author") }
        post_active_field = build(:active_value).active_field.tap { _1.update!(customizable_type: "Post") }

        [author_active_field, post_active_field]
      end

      it "returns active_fields for provided model only" do
        expect(record.active_fields.to_a)
          .to include(*active_fields.select { |field| field.customizable_type == described_class.name })
          .and exclude(*active_fields.reject { |field| field.customizable_type == described_class.name })
      end
    end
  end
end
