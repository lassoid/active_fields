# frozen_string_literal: true

RSpec.shared_examples "custom_field" do |factory:|
  context "associations" do
    it { is_expected.to have_many(:custom_fields).with_foreign_key(:definition_id).dependent(:destroy) }
  end

  context "validations" do
    subject(:record) { build(factory) }

    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:customizable_type) }

    it do
      expect(record).to validate_inclusion_of(:customizable_type)
        .in_array(CustomFieldDefinition::CUSTOMIZABLE_TYPE_SHORTHANDS.values)
    end

    context "name format" do
      subject(:record) { build(factory, name: name) }

      context "when contains lowercase alphanumerics and underscores only" do
        let(:name) { "abcxyz_123456789" }

        it "is valid" do
          record.valid?
          expect(record.errors.of_kind?(:name, :invalid)).to be(false)
        end
      end

      context "when contains uppercase alphanumerics" do
        let(:name) { "ABCXYZ_123456789" }

        it "is invalid" do
          record.valid?
          expect(record.errors.of_kind?(:name, :invalid)).to be(true)
        end
      end

      context "when contains not only lowercase alphanumerics and underscores" do
        let(:name) { "abc.123(){}" }

        it "is invalid" do
          record.valid?
          expect(record.errors.of_kind?(:name, :invalid)).to be(true)
        end
      end
    end
  end

  context "scopes" do
    describe "#for" do
      let_it_be(:user_record) { create(factory, :for_users) }

      it "returns users custom fields definitions only" do
        expect(described_class.for("User").to_a).to include(user_record)
      end
    end

    describe "#with_name" do
      let_it_be(:record1) { create(factory) }
      let_it_be(:record2) { create(factory) }

      it "returns user custom fields definitions only" do
        expect(described_class.with_name(record1.name).to_a).to include(record1).and exclude(record2)
      end
    end
  end

  context "methods" do
    let(:record) { build(factory) }

    describe "#field_validator" do
      subject(:call_method) { record.field_validator }

      it do
        expect(call_method)
          .to eq("Lasso::CustomFields::#{record.model_name.name.demodulize}Validator".constantize.new)
      end
    end

    describe "#field_caster" do
      subject(:call_method) { record.field_caster }

      it do
        expect(call_method)
          .to eq("Lasso::CustomFields::#{record.model_name.name.demodulize}Caster".constantize.new)
      end
    end

    describe "#customizable_model" do
      subject(:call_method) { record.customizable_model }

      it { is_expected.to eq(record.customizable_type.constantize) }
    end
  end
end
