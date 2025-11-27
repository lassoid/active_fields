# frozen_string_literal: true

RSpec.shared_examples "active_field" do |factory:, available_traits:, **opts|
  it "is a subclass of the configured field base class" do
    expect(described_class.superclass).to eq(ActiveFields.config.field_base_class)
  end

  context "validations" do
    subject(:record) { build(factory, *traits, **attributes) }

    let(:traits) { [] }
    let(:attributes) { {} }

    available_traits
      .map { |t| [nil, t] }
      .then { |el| el.any? ? el[0].product(*el[1..-1]) : [] }
      .each do |traits_combination|
      traits_combination = traits_combination.compact # rubocop:disable RSpec/LeakyLocalVariable

      context "with traits: [#{traits_combination.join(", ")}]" do
        let(:traits) { traits_combination }

        it { is_expected.to be_valid }
      end
    end

    describe "#validate_name_uniqueness" do
      context "when customizable model does not have scope" do
        let(:attributes) { { customizable_type: customizable_model.name, name: name } }
        let(:customizable_model) { customizable_models_for(described_class.name).sample }

        before do
          create(
            active_field_factories_for(customizable_model).sample,
            customizable_type: customizable_model.name,
            name: "taken_name",
          )
        end

        context "when name is taken" do
          let(:name) { "taken_name" }

          it "is invalid" do
            record.valid?

            expect(record.errors.where(:name, :taken)).not_to be_empty
          end
        end

        context "when name is not taken" do
          let(:name) { random_string }

          it "is valid" do
            record.valid?

            expect(record.errors.where(:name)).to be_empty
          end
        end
      end

      context "when customizable model has scope" do
        let(:attributes) { { customizable_type: customizable_model.name, name: name, scope: scope } }
        let(:customizable_model) { scoped_dummy_model }

        before do
          create(
            active_field_factories_for(customizable_model).sample,
            customizable_type: customizable_model.name,
            name: "taken_name_global",
            scope: nil,
          )
          create(
            active_field_factories_for(customizable_model).sample,
            customizable_type: customizable_model.name,
            name: "taken_name_scoped",
            scope: "taken_scope",
          )
        end

        context "when scope is nil" do
          let(:scope) { nil }

          context "when name is taken globally" do
            let(:name) { "taken_name_global" }

            it "is invalid" do
              record.valid?

              expect(record.errors.where(:name, :taken)).not_to be_empty
            end
          end

          context "when name is taken by some scope" do
            let(:name) { "taken_name_scoped" }

            it "is invalid" do
              record.valid?

              expect(record.errors.where(:name, :taken)).not_to be_empty
            end
          end

          context "when name is not taken" do
            let(:name) { random_string }

            it "is valid" do
              record.valid?

              expect(record.errors.where(:name)).to be_empty
            end
          end
        end

        context "when scope is not nil" do
          let(:scope) { "scope" }

          context "when name is taken globally" do
            let(:name) { "taken_name_global" }

            it "is invalid" do
              record.valid?

              expect(record.errors.where(:name, :taken)).not_to be_empty
            end
          end

          context "when name is taken by this scope" do
            let(:scope) { "taken_scope" }
            let(:name) { "taken_name_scoped" }

            it "is invalid" do
              record.valid?

              expect(record.errors.where(:name, :taken)).not_to be_empty
            end
          end

          context "when name is taken by other scope" do
            let(:name) { "taken_name_scoped" }

            it "is valid" do
              record.valid?

              expect(record.errors.where(:name)).to be_empty
            end
          end

          context "when name is not taken" do
            let(:name) { random_string }

            it "is valid" do
              record.valid?

              expect(record.errors.where(:name)).to be_empty
            end
          end
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
      context "when customizable_model allows this type" do
        let(:allowed_types) { [record.type_name] }

        before do
          allow(ActiveFields.registry).to receive(:field_type_names_for).with(record.customizable_type)
            .and_return(allowed_types)
        end

        it "is valid" do
          record.valid?

          expect(record.errors.where(:customizable_type)).to be_empty
        end
      end

      context "when customizable_model does not allow this type" do
        let(:allowed_types) { ActiveFields.config.type_names - [record.type_name] }

        before do
          allow(ActiveFields.registry).to receive(:field_type_names_for).with(record.customizable_type)
            .and_return(allowed_types)
        end

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:customizable_type, :inclusion)).not_to be_empty
        end
      end

      context "when customizable_model does not have active_fields" do
        before do
          allow(ActiveFields.registry).to receive(:field_type_names_for).with(record.customizable_type).and_return([])
        end

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:customizable_type, :inclusion)).not_to be_empty
        end
      end

      context "when customizable_type is invalid" do
        let(:attributes) { { customizable_type: "invalid const" } }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:customizable_type, :inclusion)).not_to be_empty
        end
      end
    end
  end

  context "scopes" do
    describe "#for" do
      let!(:global_record) { create(factory, customizable_type: customizable_type) }
      let!(:scoped_record) { create(factory, customizable_type: customizable_type, scope: "scope") }
      let!(:other_scoped_record) { create(factory, customizable_type: customizable_type, scope: "other_scope") }
      let!(:other_customizable_record) do
        create(factory, customizable_type: customizable_models_for(described_class.name).sample.name)
      end

      let(:customizable_type) { scoped_dummy_model.name }

      context "without scope parameter" do
        subject(:call_scope) { described_class.for(customizable_type).to_a }

        it "returns only global records" do
          expect(call_scope)
            .to include(global_record)
            .and exclude(scoped_record, other_scoped_record, other_customizable_record)
        end
      end

      context "with scope parameter" do
        subject(:call_scope) { described_class.for(customizable_type, scope: "scope").to_a }

        it "returns records with given scope and global records" do
          expect(call_scope)
            .to include(global_record, scoped_record)
            .and exclude(other_scoped_record, other_customizable_record)
        end
      end
    end
  end

  context "methods" do
    let(:record) { build(factory) }

    describe "#value_validator_class" do
      subject(:call_method) { record.value_validator_class }

      it "returns validator class" do
        expect(call_method).to eq(
          (
            opts[:validator_class] || "ActiveFields::Validators::#{record.model_name.name.demodulize}Validator"
          ).constantize,
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
          (opts[:caster_class] || "ActiveFields::Casters::#{record.model_name.name.demodulize}Caster").constantize,
        )
      end
    end

    describe "#value_caster" do
      subject(:call_method) { record.value_caster }

      it { is_expected.to be_an_instance_of(record.value_caster_class) }
    end

    describe "#value_finder_class" do
      subject(:call_method) { record.value_finder_class }

      it "returns finder class" do
        if opts.key?(:finder_class)
          expect(call_method).to eq(opts[:finder_class]&.constantize)
        else
          expect(call_method).to eq("ActiveFields::Finders::#{record.model_name.name.demodulize}Finder".constantize)
        end
      end
    end

    describe "#value_finder" do
      subject(:call_method) { record.value_finder }

      it "returns an instance of configured class or nil" do
        if record.value_finder_class
          expect(call_method).to be_an_instance_of(record.value_finder_class)
        else
          expect(call_method).to be_nil
        end
      end
    end

    describe "#customizable_model" do
      subject(:call_method) { record.customizable_model }

      it { is_expected.to eq(record.customizable_type.constantize) }

      context "when invalid" do
        before do
          record.customizable_type = "invalid const"
        end

        it { is_expected.to be_nil }
      end
    end

    describe "#default_value" do
      subject(:call_method) { record.default_value }

      it { is_expected.to eq(record.value_caster.deserialize(record.default_value_meta["const"])) }
    end

    describe "#default_value=" do
      subject(:call_method) { record.default_value = value }

      let(:value) { active_value_for(record) }

      it "sets default_value" do
        call_method

        expect(record.default_value_meta["const"]).to eq(record.value_caster.serialize(value))
      end
    end

    describe "#type_name" do
      subject(:call_method) { record.type_name }

      it { is_expected.to eq(ActiveFields.config.fields.key(record.type)) }
    end
  end

  context "callbacks" do
    describe "before_validation #set_scope" do
      let(:record) { build(factory, customizable_type: customizable_type, scope: "some_scope") }

      context "when customizable model does not have scope" do
        let(:customizable_type) { customizable_models_for(described_class.name).sample.name }

        it "sets scope to nil" do
          expect do
            record.valid?
          end.to change(record, :scope).to(nil)
        end
      end

      context "when customizable model has scope" do
        let(:customizable_type) { scoped_dummy_model.name }

        it "does not change scope" do
          expect do
            record.valid?
          end.to not_change(record, :scope)
        end
      end
    end
  end
end
