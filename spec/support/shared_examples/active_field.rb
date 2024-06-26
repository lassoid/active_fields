# frozen_string_literal: true

RSpec.shared_examples "active_field" do |factory:, available_traits:, validator_class: nil, caster_class: nil|
  it "is a subclass of the configured field base class" do
    expect(described_class.superclass).to eq(ActiveFields.config.field_base_class)
  end

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

    describe "#validate_customizable_model_allows_type" do
      let(:config) { ActiveFields::CustomizableConfig.new(described_class) }
      let(:type_name) { ActiveFields.config.fields.key(record.type) }

      before do
        allow(record.customizable_model).to receive(:active_fields_config).and_return(config)
      end

      context "when customizable_model allows this type" do
        before do
          allow(config).to receive(:types).and_return([type_name])
        end

        it "is valid" do
          record.valid?

          expect(record.errors.where(:customizable_type)).to be_empty
        end
      end

      context "when customizable_model does not allow this type" do
        before do
          allow(config).to receive(:types).and_return(ActiveFields.config.fields.keys - [type_name])
        end

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:customizable_type, :inclusion)).not_to be_empty
        end
      end

      context "when customizable_model does not have active_fields" do
        let(:config) { nil }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:customizable_type, :inclusion)).not_to be_empty
        end
      end
    end
  end

  context "scopes" do
    describe "#for" do
      let!(:active_fields) do
        customizable_models_for(described_class.name).map do |customizable_model|
          create(factory, customizable_type: customizable_model.name)
        end
      end

      let!(:other_type_active_fields) do
        other_allowed_active_field_factories = active_field_factories_for(customizable_type.constantize) - [factory]
        other_allowed_active_field_factories.map do |active_field_factory|
          create(active_field_factory, customizable_type: customizable_type)
        end
      end

      let(:customizable_type) { active_fields.sample.customizable_type }

      it "returns active_fields for provided model only" do
        expect(described_class.for(customizable_type).to_a)
          .to include(*active_fields.select { |field| field.customizable_type == customizable_type })
          .and exclude(*active_fields.reject { |field| field.customizable_type == customizable_type })
          .and exclude(*other_type_active_fields)
      end
    end
  end

  context "methods" do
    let(:record) { build(factory) }

    describe "#value_validator_class" do
      subject(:call_method) { record.value_validator_class }

      it "returns validator class" do
        expect(call_method).to eq(
          (validator_class || "ActiveFields::Validators::#{record.model_name.name.demodulize}Validator").constantize,
        )
      end
    end

    describe "#value_validator" do
      subject(:call_method) { record.value_validator }

      it { is_expected.to be_an_instance_of(record.value_validator_class) }
    end

    describe "#value_caster_class" do
      subject(:call_method) { record.value_caster_class }

      it "returns caster class" do
        expect(call_method).to eq(
          (caster_class || "ActiveFields::Casters::#{record.model_name.name.demodulize}Caster").constantize,
        )
      end
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

  context "callbacks" do
    describe "after_create #add_field_to_records" do
      subject(:create_field) { record.save! }

      let!(:customizable) { customizable_models_for(described_class.name).sample.create! }

      available_traits.map { [nil, _1] }.then { _1[0].product(*_1[1..-1]) }.each do |traits_combination|
        traits_combination = traits_combination.compact

        context "with traits: [#{traits_combination.join(", ")}]" do
          let(:record) { build(factory, *traits_combination, customizable_type: customizable.class.name) }

          it "creates active_value for customizable" do
            expect do
              create_field
              customizable.reload
            end.to change { customizable.active_values.size }.by(1)
          end

          it "sets active_value value" do
            create_field
            customizable.reload

            expect(customizable.active_values.take!.value).to eq(record.default_value)
          end
        end
      end
    end
  end
end
