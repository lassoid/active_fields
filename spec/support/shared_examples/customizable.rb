# frozen_string_literal: true

RSpec.shared_examples "customizable" do
  it_behaves_like "base_customizable"

  context "methods" do
    let(:record) { described_class.new }

    describe "##active_fields_scope_method" do
      subject(:call_method) { described_class.active_fields_scope_method }

      it { is_expected.to be_nil }
    end

    describe "##active_fields_scope" do
      subject(:call_method) { record.active_fields_scope }

      it { is_expected.to be_nil }
    end

    describe "##active_fields" do
      subject(:call_method) { described_class.active_fields }

      let!(:active_fields) do
        (dummy_models + [scoped_dummy_model]).map do |model|
          active_field_factories_for(model).map do |active_field_factory|
            create(active_field_factory, customizable_type: model.name)
          end
        end.flatten
      end

      it "returns active_fields for provided model only" do
        expect(call_method.to_a)
          .to include(*active_fields.select { |field| field.customizable_type == described_class.name })
          .and exclude(*active_fields.reject { |field| field.customizable_type == described_class.name })
      end
    end

    describe "#active_fields" do
      subject(:call_method) { record.active_fields }

      let(:record) { described_class.create! }

      let!(:active_fields) do
        (dummy_models + [scoped_dummy_model]).map do |model|
          active_field_factories_for(model).map do |active_field_factory|
            create(active_field_factory, customizable_type: model.name)
          end
        end.flatten
      end

      it "returns active_fields for provided model only" do
        expect(call_method.to_a)
          .to include(*active_fields.select { |field| field.customizable_type == described_class.name })
          .and exclude(*active_fields.reject { |field| field.customizable_type == described_class.name })
      end
    end
  end
end
