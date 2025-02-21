# frozen_string_literal: true

RSpec.describe Group do
  it "is not a customizable" do
    expect(described_class.ancestors).not_to include(ActiveFields::CustomizableConcern)
  end
end
