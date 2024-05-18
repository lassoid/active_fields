# frozen_string_literal: true

RSpec.describe ActiveFields::Value do
  it "has a valid factory" do
    expect(build(:active_value)).to be_valid
  end

  context "validations" do
    let(:record) { build(:active_value) }

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
        let(:customizable) { Post.new }
        let(:record) { build(:active_value, customizable: customizable) }

        before do
          record.active_field.customizable_type = customizable_type
        end

        context "when customizable types are equal" do
          let(:customizable_type) { "Post" }

          it "doesn't add errors" do
            record.valid?

            expect(record.errors.where(:customizable)).to be_empty
          end
        end

        context "when customizable types are different" do
          let(:customizable_type) { "Comment" }

          it "adds an error" do
            record.valid?

            expect(record.errors.where(:customizable, :invalid)).not_to be_empty
          end
        end
      end
    end
  end

  context "methods" do
    describe "#value" do
      subject(:call_method) { record.value }

      let(:record) { build(:active_value) }

      it { is_expected.to eq(record.active_field.value_caster.deserialize(record.attributes["value"])) }

      context "without active_field" do
        before do
          record.active_field = nil
        end

        it { is_expected.to be_nil }
      end
    end

    describe "#value=" do
      subject(:call_method) { record.value = value }

      let(:record) { build(:active_value, value: nil) }
      let(:value) { build(:active_value, active_field: record.active_field).value }

      it "sets value" do
        call_method

        expect(record.value)
          .to eq(record.active_field.value_caster.deserialize(record.active_field.value_caster.serialize(value)))
      end

      context "without active_field" do
        before do
          record.active_field = nil
        end

        it "sets nil" do
          call_method

          expect(record.attributes["value"]).to be_nil
        end
      end
    end
  end
end
