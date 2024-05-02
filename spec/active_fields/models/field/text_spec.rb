# frozen_string_literal: true

RSpec.xdescribe ActiveFields::Field::Text do
  it_behaves_like "custom_field", factory: :text_custom_field_definition

  it "has a valid factory" do
    expect(build(:text_custom_field_definition)).to be_valid
  end

  context "validations" do
    subject { build(:text_custom_field_definition) }

    it { is_expected.to validate_exclusion_of(:required).in_array([nil]) }
    it { is_expected.to validate_exclusion_of(:multiple).in_array([nil]) }

    context "when required" do
      subject { build(:text_custom_field_definition, :required) }

      it { is_expected.to validate_presence_of(:default) }
    end

    context "when not required" do
      it { is_expected.not_to validate_presence_of(:default) }
    end

    context "with allowed values" do
      subject { build(:text_custom_field_definition, allowed_values: allowed_values) }

      let(:allowed_values) { ["this is allowed", "and this too"] }

      it { is_expected.to validate_inclusion_of(:default).in_array(allowed_values).allow_blank }
    end

    context "without allowed values" do
      subject { build(:text_custom_field_definition, allowed_values: [nil, 1].sample) }

      it { is_expected.not_to validate_inclusion_of(:default).in_array([]).allow_blank }
    end

    context "allowed_values is an array" do
      subject(:record) { build(:text_custom_field_definition, allowed_values: allowed_values) }

      context "when nil" do
        let(:allowed_values) { nil }

        it "is invalid" do
          expect(record).not_to be_valid
          expect(record.errors.of_kind?(:allowed_values, :not_an_array)).to be(true)
        end
      end

      context "when not an array" do
        let(:allowed_values) { 1 }

        it "is invalid" do
          expect(record).not_to be_valid
          expect(record.errors.of_kind?(:allowed_values, :not_an_array)).to be(true)
        end
      end

      context "when an empty array" do
        let(:allowed_values) { [] }

        it "is invalid" do
          expect(record).to be_valid
        end
      end

      context "when an array" do
        let(:allowed_values) { ["test value"] }

        it "is invalid" do
          expect(record).to be_valid
        end
      end
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

      context "when allowed_values is nil" do
        let(:record) { described_class.new }

        it "sets empty array" do
          expect(record.allowed_values).to eq([])
        end
      end

      context "when allowed_values is not nil" do
        let(:record) { described_class.new(allowed_values: ["test option"]) }

        it "doesn't change column" do
          expect(record.allowed_values).to eq(["test option"])
        end
      end
    end

    describe "after_create #add_field_to_records" do
      let_it_be(:customizable, refind: true) { create(:user) }

      let(:record) { build(:text_custom_field_definition) }

      it "creates custom field for customizable" do
        expect do
          record.save!
          customizable.reload
        end.to change { customizable.custom_fields.count }.by(1)
      end

      context "when default is present" do
        let(:record) { build(:text_custom_field_definition, default: "default value") }

        it "sets custom field value" do
          record.save!

          caster = record.field_caster

          expect(customizable.custom_fields.take!.value).to eq(
            caster.deserialize(caster.serialize(record.default)),
          )
        end
      end

      context "when default is present and multiple enabled" do
        let(:record) { build(:text_custom_field_definition, :multiple, default: "default value") }

        it "sets custom field value" do
          record.save!

          caster = record.field_caster

          expect(customizable.custom_fields.take!.value).to eq(
            caster.deserialize(caster.serialize(record.default)),
          )
        end
      end

      context "when default is nil" do
        let(:record) { build(:text_custom_field_definition, default: nil) }

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
