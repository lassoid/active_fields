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
    end
  end

  context "methods" do
    let(:record) { build(factory) }

    describe "#value" do
      subject(:call_method) { record.value }

      it { is_expected.to eq(record.active_field.value_caster.deserialize(record.attributes["value_meta"]["const"])) }

      context "without active_field" do
        before do
          record.active_field = nil
        end

        it { is_expected.to be_nil }
      end
    end

    describe "#value=" do
      subject(:call_method) { record.value = value }

      let(:value) { active_value_for(record.active_field) }

      it "sets value" do
        call_method

        expect(record.attributes["value_meta"]["const"]).to eq(record.active_field.value_caster.serialize(value))
      end

      context "without active_field" do
        let(:value) { build(factory).value }

        before do
          record.active_field = nil
        end

        it "sets nil" do
          call_method

          expect(record.value).to be_nil
        end
      end
    end
  end
end
