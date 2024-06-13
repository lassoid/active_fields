# frozen_string_literal: true

RSpec.describe Author do
  include_examples "customizable"

  context "active_fields configuration" do
    it "allows all types by default" do
      expect(described_class.active_fields_config.types).to eq(ActiveFields.config.fields.keys)
    end
  end
end
