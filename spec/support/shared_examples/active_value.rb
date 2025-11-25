# frozen_string_literal: true

RSpec.shared_examples "active_value" do |factory:|
  context "validations" do
    let(:record) { build(factory) }

    describe "#validate_value" do
      context "without active_field" do
        before do
          record.active_field = nil
        end

        it "doesn't add errors" do
          record.valid?

          expect(record.errors.where(:value)).to be_empty
        end
      end

      context "with active_field" do
        before do
          validator = instance_double(record.active_field.value_validator_class, errors: validator_errors)
          allow(record.active_field).to receive(:value_validator).and_return(validator)
          allow(validator).to receive(:validate).with(record.value).and_return(validator_errors.empty?)
        end

        context "when validator returns success" do
          let(:validator_errors) { Set.new }

          it "doesn't add errors" do
            record.valid?

            expect(record.errors.where(:value)).to be_empty
          end
        end

        context "when validator returns error" do
          let(:validator_errors) { Set.new([:invalid, [:greater_than, count: random_number]]) }

          it "adds errors from validator" do
            record.valid?

            validator_errors.each do |error|
              expect(record.errors.added?(:value, *error)).to be(true)
            end
          end
        end
      end
    end

    describe "#validate_customizable_allowed" do
      context "without active_field" do
        before do
          record.active_field = nil
        end

        it "doesn't add errors" do
          record.valid?

          expect(record.errors.where(:customizable)).to be_empty
        end
      end

      context "with active_field" do
        before do
          record.active_field.customizable_type = customizable_type
        end

        context "when customizable types are equal" do
          let(:customizable_type) { record.customizable.class.name }

          it "doesn't add errors" do
            record.valid?

            expect(record.errors.where(:customizable)).to be_empty
          end
        end

        context "when customizable types are different" do
          let(:customizable_type) { (dummy_models - [record.customizable.class]).sample.name }

          it "adds an error" do
            record.valid?

            expect(record.errors.where(:customizable, :invalid)).not_to be_empty
          end
        end
      end

      context "when customizable model has scope" do
        let(:active_field) do
          build(random_active_field_factory, customizable_type: scoped_dummy_model.name, scope: field_scope)
        end
        let(:customizable) do
          scoped_dummy_model.build(scoped_dummy_model.active_fields_scope_method => customizable_scope)
        end

        before do
          record.active_field = active_field
          record.customizable = customizable
        end

        context "when active_field scope is nil" do
          let(:field_scope) { nil }
          let(:customizable_scope) { [random_string, nil].sample }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:customizable)).to be_empty
          end
        end

        context "when scopes are equal" do
          let(:field_scope) { random_string }
          let(:customizable_scope) { field_scope }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:customizable)).to be_empty
          end
        end

        context "when scopes are different" do
          let(:field_scope) { random_string }
          let(:customizable_scope) { random_string }

          it "is invalid" do
            record.valid?

            expect(record.errors.where(:customizable, :invalid)).not_to be_empty
          end
        end
      end
    end
  end

  context "callbacks" do
    describe "before_validation #assign_value_from_temp" do
      let(:record) { ActiveFields.config.value_class.new }
      let(:active_field) { build(random_active_field_factory) }
      let(:value) { active_value_for(active_field) }

      context "with active_field and temp_value" do
        before do
          # Assign the value before the active_field to set temp_value
          record.value = value
          record.active_field = active_field
        end

        it "sets the value from temp variable and clears it" do
          record.valid?

          expect(record.temp_value).to be_nil
          # Do not use value getter, because it triggers this callback too
          expect(record.active_field.value_caster.deserialize(record.value_meta["const"])).to eq(value)
        end
      end

      context "without active_field" do
        before do
          # Set temp_value
          record.value = value
        end

        it "doesn't change value and temp variable" do
          record.valid?

          expect(record.temp_value["value"]).to eq(value)
          # Do not use value getter, because it triggers this callback too
          expect(record.value_meta["const"]).to be_nil
        end
      end

      context "without temp_value" do
        before do
          record.active_field = active_field
        end

        it "doesn't change value" do
          record.valid?

          # Do not use value getter, because it triggers this callback too
          expect(record.value_meta["const"]).to be_nil
        end
      end
    end
  end

  context "methods" do
    let(:record) { build(factory, active_field: active_field) }
    let(:active_field) { build(random_active_field_factory) }

    describe "#value" do
      subject(:call_method) { record.value }

      it "doesn't change value" do
        expect do
          call_method
        end.to not_change { record.value_meta["const"] }
      end

      it { is_expected.to eq(record.active_field.value_caster.deserialize(record.value_meta["const"])) }

      context "without active_field" do
        before do
          record.active_field = nil
        end

        it "doesn't change value" do
          expect do
            call_method
          end.to not_change { record.value_meta["const"] }
        end

        it { is_expected.to be_nil }
      end

      context "with temp value" do
        let(:value) { active_value_for(active_field) }

        before do
          # Temporarily remove the active_field to save the value in a temp variable, then restore it
          record.active_field = nil
          record.value = value
          record.active_field = active_field
        end

        it "sets value from temp variable and clears it" do
          call_method

          expect(record.temp_value).to be_nil
          expect(record.active_field.value_caster.deserialize(record.value_meta["const"])).to eq(value)
        end

        it { is_expected.to eq(value) }
      end
    end

    describe "#value=" do
      subject(:call_method) { record.value = value }

      let(:value) { active_value_for(active_field) }

      it "sets value" do
        call_method

        expect(record.value_meta["const"]).to eq(record.active_field.value_caster.serialize(value))
        expect(record.temp_value).to be_nil
      end

      context "without active_field" do
        before do
          record.active_field = nil
        end

        it "sets temp variable, not value itself" do
          expect do
            call_method
          end.to not_change { record.value_meta["const"] }

          expect(record.temp_value["value"]).to eq(value)
        end
      end

      context "with temp_value" do
        before do
          # Temporarily remove the active_field to save the value in a temp variable, then restore it
          record.active_field = nil
          record.value = active_value_for(active_field)
          record.active_field = active_field
        end

        it "sets the value and clears temp variable" do
          expect do
            call_method
          end.to change(record, :temp_value).to(nil)

          expect(record.value_meta["const"]).to eq(record.active_field.value_caster.serialize(value))
        end
      end
    end

    describe "#name" do
      subject(:call_method) { record.name }

      context "with active_field" do
        it { is_expected.to eq(record.active_field.name) }
      end

      context "without active_field" do
        let(:active_field) { nil }

        it { is_expected.to be_nil }
      end
    end
  end
end
