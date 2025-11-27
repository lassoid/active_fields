# frozen_string_literal: true

RSpec.shared_examples "scoped_customizable" do
  it_behaves_like "base_customizable"

  context "scopes" do
    # rubocop:disable RSpec/MultipleMemoizedHelpers
    describe "#where_active_fields" do
      subject(:call_scope) { described_class.where_active_fields(args, scope: scope).to_a }

      def search_op(active_field) = "operator_#{active_field.id}"
      def search_value(active_field) = "value_#{active_field.id}"

      let(:args) do
        [{
          name: active_field.name,
          operator: search_op(active_field),
          value: search_value(active_field),
        }]
      end
      let(:scope) { random_string }

      let(:active_field_without_scope) do
        factory = (active_field_factories_for(described_class) - [:ip_array_field]).sample
        create(factory, customizable_type: described_class.name, scope: nil)
      end
      let(:active_field_with_scope) do
        factory = (active_field_factories_for(described_class) - [:ip_array_field]).sample
        create(factory, customizable_type: described_class.name, scope: scope)
      end

      let!(:records) do
        Array.new(4) do
          described_class.create!(
            described_class.active_fields_scope_method => scope,
            active_fields_attributes: [
              { name: active_field_without_scope.name, value: active_value_for(active_field_without_scope) },
              { name: active_field_with_scope.name, value: active_value_for(active_field_with_scope) },
            ],
          )
        end
      end
      let(:expected_ids) { records.sample(2).map(&:id) }

      before do
        finder = instance_double(active_field.value_finder_class)
        allow(active_field.value_finder_class).to receive(:new).and_return(finder)

        allow(finder).to receive(:search).with(
          op: search_op(active_field),
          value: search_value(active_field),
        ).and_return(
          active_field.active_values.where(customizable_id: expected_ids),
        )
      end

      context "with nil scope active_field" do
        let(:active_field) { active_field_without_scope }

        it "returns records with matching active_values" do
          expect(call_scope)
            .to include(*described_class.where(id: expected_ids).to_a)
            .and exclude(*described_class.where.not(id: expected_ids).to_a)
        end
      end

      context "with same scope active_field" do
        let(:active_field) { active_field_with_scope }

        it "returns records with matching active_values" do
          expect(call_scope)
            .to include(*described_class.where(id: expected_ids).to_a)
            .and exclude(*described_class.where.not(id: expected_ids).to_a)
        end
      end

      context "with another scope active_field" do
        let(:active_field) do
          factory = (active_field_factories_for(described_class) - [:ip_array_field]).sample
          create(factory, customizable_type: described_class.name, scope: random_string)
        end

        it "skips search and returns all customizables" do
          expect(call_scope).to include(*described_class.all.to_a)
        end
      end
      # rubocop:enable RSpec/MultipleMemoizedHelpers
    end
  end

  context "methods" do
    describe "##active_fields" do
      subject(:call_method) { described_class.active_fields(scope: scope) }

      let!(:active_fields) do
        ordinary_active_fields = dummy_models.map do |model|
          active_field_factories_for(model).map do |active_field_factory|
            create(active_field_factory, customizable_type: model.name)
          end
        end.flatten
        scoped_active_fields = active_field_factories_for(scoped_dummy_model).map do |active_field_factory|
          [nil, scope, random_string].uniq.map do |scope|
            create(active_field_factory, customizable_type: scoped_dummy_model.name, scope: scope)
          end
        end.flatten

        ordinary_active_fields + scoped_active_fields
      end

      context "when scope is nil" do
        let(:scope) { nil }

        it "returns active_fields for provided model only and with nil scope" do
          included = active_fields.select do |field|
            field.customizable_type == described_class.name && field.scope.nil?
          end
          excluded = active_fields.reject do |field|
            field.customizable_type == described_class.name && field.scope.nil?
          end
          expect(call_method.to_a).to include(*included).and exclude(*excluded)
        end
      end

      context "when scope is not nil" do
        let(:scope) { random_string }

        it "returns active_fields for provided model only and with nil or equal scope" do
          included = active_fields.select do |field|
            field.customizable_type == described_class.name && (field.scope.nil? || field.scope == scope)
          end
          excluded = active_fields.reject do |field|
            field.customizable_type == described_class.name && (field.scope.nil? || field.scope == scope)
          end
          expect(call_method.to_a).to include(*included).and exclude(*excluded)
        end
      end
    end

    describe "#active_fields" do
      subject(:call_method) { record.active_fields }

      let(:record) { described_class.create!(described_class.active_fields_scope_method => scope) }

      let!(:active_fields) do
        ordinary_active_fields = dummy_models.map do |model|
          active_field_factories_for(model).map do |active_field_factory|
            create(active_field_factory, customizable_type: model.name)
          end
        end.flatten
        scoped_active_fields = active_field_factories_for(scoped_dummy_model).map do |active_field_factory|
          [nil, scope, random_string].uniq.map do |scope|
            create(active_field_factory, customizable_type: scoped_dummy_model.name, scope: scope)
          end
        end.flatten

        ordinary_active_fields + scoped_active_fields
      end

      context "when scope is nil" do
        let(:scope) { nil }

        it "returns active_fields for provided model only and with nil scope" do
          included = active_fields.select do |field|
            field.customizable_type == described_class.name && field.scope.nil?
          end
          excluded = active_fields.reject do |field|
            field.customizable_type == described_class.name && field.scope.nil?
          end
          expect(call_method.to_a).to include(*included).and exclude(*excluded)
        end
      end

      context "when scope is not nil" do
        let(:scope) { random_string }

        it "returns active_fields for provided model only and with nil or equal scope" do
          included = active_fields.select do |field|
            field.customizable_type == described_class.name && (field.scope.nil? || field.scope == scope)
          end
          excluded = active_fields.reject do |field|
            field.customizable_type == described_class.name && (field.scope.nil? || field.scope == scope)
          end
          expect(call_method.to_a).to include(*included).and exclude(*excluded)
        end
      end
    end
  end
end
