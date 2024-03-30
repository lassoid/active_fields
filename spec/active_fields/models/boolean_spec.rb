# frozen_string_literal: true

RSpec.xdescribe ActiveFields::Field::Boolean do
  it_behaves_like "custom_field", factory: :boolean_active_field

  it "has a valid factory" do
    expect(build(:boolean_active_field)).to be_valid
  end

  context "validations" do
    subject { build(:boolean_active_field) }

    it { is_expected.to validate_exclusion_of(:required).in_array([nil]) }
    it { is_expected.to validate_exclusion_of(:nullable).in_array([nil]) }
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
        let(:value) { [true, false].sample }
        let(:record) { described_class.new(required: value) }

        it "doesn't change column" do
          expect(record.required).to be(value)
        end
      end

      context "when nullable is nil" do
        let(:record) { described_class.new }

        it "sets false" do
          expect(record.nullable).to be(false)
        end
      end

      context "when nullable is not nil" do
        let(:value) { [true, false].sample }
        let(:record) { described_class.new(nullable: value) }

        it "doesn't change column" do
          expect(record.nullable).to be(value)
        end
      end
    end

    describe "after_create #add_field_to_records" do
      let_it_be(:customizable, refind: true) { create(:user) }

      let(:record) { build(:boolean_active_field) }

      it "creates custom field for customizable" do
        expect do
          record.save!
          customizable.reload
        end.to change { customizable.custom_fields.count }.by(1)
      end

      context "when default is present" do
        let(:record) { build(:boolean_active_field, default: [true, false].sample) }

        it "sets custom field value" do
          record.save!

          caster = record.field_caster

          expect(customizable.custom_fields.take!.value).to eq(
            caster.deserialize(caster.serialize(record.default)),
          )
        end
      end

      context "when default is nil" do
        let(:record) { build(:boolean_active_field, default: nil) }

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
