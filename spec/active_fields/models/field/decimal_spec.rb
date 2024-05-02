# frozen_string_literal: true

RSpec.xdescribe ActiveFields::Field::Decimal do
  it_behaves_like "custom_field", factory: :decimal_custom_field_definition

  it "has a valid factory" do
    expect(build(:decimal_custom_field_definition)).to be_valid
  end

  context "validations" do
    subject { build(:decimal_custom_field_definition) }

    it { is_expected.to validate_exclusion_of(:required).in_array([nil]) }
    it { is_expected.to validate_exclusion_of(:multiple).in_array([nil]) }

    context "when required" do
      subject { build(:decimal_custom_field_definition, :required) }

      it { is_expected.to validate_presence_of(:default) }
    end

    context "when not required" do
      it { is_expected.not_to validate_presence_of(:default) }
    end

    context "with min" do
      subject { build(:decimal_custom_field_definition, min: min) }

      let(:min) { rand(0..10).to_f }

      it { is_expected.to validate_numericality_of(:max).is_greater_than_or_equal_to(min).allow_nil }
      it { is_expected.to validate_numericality_of(:default).is_greater_than_or_equal_to(min).allow_nil }
    end

    context "without min" do
      it { is_expected.not_to validate_numericality_of(:max) }
      it { is_expected.not_to validate_numericality_of(:default) }
    end

    context "with max" do
      subject { build(:decimal_custom_field_definition, max: max) }

      let(:max) { rand(0..10).to_f }

      it { is_expected.to validate_numericality_of(:default).is_less_than_or_equal_to(max).allow_nil }
    end

    context "without max" do
      it { is_expected.not_to validate_numericality_of(:default) }
    end
  end

  context "callbacks" do
    describe "after_initialize #set_defaults" do
      context "when required is nil" do
        let(:record) { described_class.new }

        it "sets false" do
          expect(record.required).to be(false)
        end
      end

      context "when required is not nil" do
        let(:record) { described_class.new(required: true) }

        it "doesn't change column" do
          expect(record.required).to be(true)
        end
      end

      context "when multiple is nil" do
        let(:record) { described_class.new }

        it "sets false" do
          expect(record.multiple).to be(false)
        end
      end

      context "when multiple is not nil" do
        let(:record) { described_class.new(multiple: true) }

        it "doesn't change column" do
          expect(record.multiple).to be(true)
        end
      end
    end

    describe "after_create #add_field_to_records" do
      let_it_be(:customizable, refind: true) { create(:user) }

      let(:record) { build(:decimal_custom_field_definition) }

      it "creates custom field for customizable" do
        expect do
          record.save!
          customizable.reload
        end.to change { customizable.custom_fields.count }.by(1)
      end

      context "when default is present" do
        let(:record) { build(:decimal_custom_field_definition, default: rand(0..10).to_f) }

        it "sets custom field value" do
          record.save!

          caster = record.field_caster

          expect(customizable.custom_fields.take!.value).to eq(
            caster.deserialize(caster.serialize(record.default)),
          )
        end
      end

      context "when default is present and multiple enabled" do
        let(:record) { build(:decimal_custom_field_definition, :multiple, default: rand(0..10).to_f) }

        it "sets custom field value" do
          record.save!

          caster = record.field_caster

          expect(customizable.custom_fields.take!.value).to eq(
            caster.deserialize(caster.serialize(record.default)),
          )
        end
      end

      context "when default is nil" do
        let(:record) { build(:decimal_custom_field_definition, default: nil) }

        it "sets custom field value" do
          record.save!

          caster = record.field_caster

          expect(customizable.custom_fields.take!.value).to eq(
            caster.deserialize(caster.serialize(record.default)),
          )
        end
      end
    end
  end
end
