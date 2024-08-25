# frozen_string_literal: true

RSpec.describe Post do
  include_examples "customizable"

  context "active_fields configuration" do
    it "allows only provided types" do
      expect(described_class.active_fields_config.types).to eq(%i[boolean date_array decimal ip])
    end
  end
end
