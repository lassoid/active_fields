# frozen_string_literal: true

RSpec.describe Group do
  it "is not a customizable" do
    expect(described_class.ancestors).not_to include(ActiveFields::CustomizableConcern)
  end

  context "active_fields configuration" do
    it "returns nil" do
      expect(described_class.active_fields_config).to be_nil
    end
  end
end
