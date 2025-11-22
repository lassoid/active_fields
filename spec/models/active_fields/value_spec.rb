# frozen_string_literal: true

RSpec.describe ActiveFields::Value do
  if ActiveFields.config.value_class_changed?
    it "is a blank class" do
      expect(described_class.superclass).to eq(Object)
      expect(described_class.ancestors).not_to include(ActiveFields::ValueConcern)
    end
  else
    it "is a model" do
      expect(described_class.superclass).to eq(ActiveFields::ApplicationRecord)
      expect(described_class.ancestors).to include(ActiveFields::ValueConcern)
    end

    factory = :active_value # rubocop:disable RSpec/LeakyLocalVariable

    it_behaves_like "active_value", factory: factory

    it "has a valid factory" do
      expect(build(factory)).to be_valid
    end
  end
end
