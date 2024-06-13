# frozen_string_literal: true

RSpec.describe ActiveFields::Field::Base do
  if ActiveFields.config.field_base_class_changed?
    it "is a blank class" do
      expect(described_class.superclass).to eq(Object)
      expect(described_class.ancestors).not_to include(ActiveFields::FieldConcern)
    end
  else
    it "is a model" do
      expect(described_class.superclass).to eq(ActiveFields::ApplicationRecord)
      expect(described_class.ancestors).to include(ActiveFields::FieldConcern)
    end
  end
end
