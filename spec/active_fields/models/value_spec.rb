# frozen_string_literal: true

RSpec.describe ActiveFields::Value do
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
