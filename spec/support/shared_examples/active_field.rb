# frozen_string_literal: true

RSpec.shared_examples "active_field" do |factory:|
  context "validations" do
    subject(:record) { build(factory) }

    context "name format" do
      subject(:record) { build(factory, name: name) }

      context "when contains lowercase alphanumerics and underscores only" do
        let(:name) { "abcxyz_123456789" }

        it "is valid" do
          record.valid?
          expect(record.errors.where(:name, :invalid)).to be_empty
        end
      end

      context "when contains uppercase alphanumerics" do
        let(:name) { "ABCXYZ_123456789" }

        it "is invalid" do
          record.valid?
          expect(record.errors.where(:name, :invalid)).not_to be_empty
        end
      end

      context "when contains not only lowercase alphanumerics and underscores" do
        let(:name) { "abc.123(){}" }

        it "is invalid" do
          record.valid?
          expect(record.errors.where(:name, :invalid)).not_to be_empty
        end
      end
    end

    describe "#validate_default_value" do
      before do
        validator = instance_double(record.value_validator_class, errors: validator_errors)
        # rubocop:disable RSpec/SubjectStub
        allow(record).to receive(:value_validator).and_return(validator)
        # rubocop:enable RSpec/SubjectStub
        allow(validator).to receive(:validate).with(record.default_value).and_return(validator_errors.empty?)
      end

      context "when validator returns success" do
        let(:validator_errors) { Set.new }

        it "doesn't add errors" do
          record.valid?

          expect(record.errors.where(:default_value)).to be_empty
        end
      end

      context "when validator returns error" do
        let(:validator_errors) { Set.new([:invalid, [:greater_than, count: random_number]]) }

        it "adds errors from validator" do
          record.valid?

          validator_errors.each do |error|
            expect(record.errors.added?(:default_value, *error)).to be(true)
          end
        end
      end
    end
  end

  context "scopes" do
    describe "#for" do
      let!(:active_fields) do
        [create(factory, customizable_type: "Author"), create(factory, customizable_type: "Post")]
      end

      it "returns active_fields for provided model only" do
        customizable_type = active_fields.sample.customizable_type

        expect(described_class.for(customizable_type).to_a)
          .to include(*active_fields.select { |field| field.customizable_type == customizable_type })
          .and exclude(*active_fields.reject { |field| field.customizable_type == customizable_type })
      end
    end
  end

  context "methods" do
    let(:record) { build(factory) }

    describe "#value_validator_class" do
      subject(:call_method) { record.value_validator_class }

      it { is_expected.to eq("ActiveFields::Validators::#{record.model_name.name.demodulize}Validator".constantize) }
    end

    describe "#value_validator" do
      subject(:call_method) { record.value_validator }

      it { is_expected.to be_an_instance_of(record.value_validator_class) }
    end

    describe "#value_caster_class" do
      subject(:call_method) { record.value_caster_class }

      it { is_expected.to eq("ActiveFields::Casters::#{record.model_name.name.demodulize}Caster".constantize) }
    end

    describe "#value_caster" do
      subject(:call_method) { record.value_caster }

      it { is_expected.to be_an_instance_of(record.value_caster_class) }
    end

    describe "#customizable_model" do
      subject(:call_method) { record.customizable_model }

      it { is_expected.to eq(record.customizable_type.constantize) }
    end

    describe "#default_value" do
      subject(:call_method) { record.default_value }

      it { is_expected.to eq(record.value_caster.deserialize(record.attributes["default_value"])) }
    end

    describe "#default_value=" do
      subject(:call_method) { record.default_value = value }

      let(:value) { active_value_for(record) }

      it "sets default_value" do
        call_method

        expect(record.default_value).to eq(
          record.value_caster.deserialize(
            record.value_caster.serialize(value),
          ),
        )
      end
    end
  end
end
