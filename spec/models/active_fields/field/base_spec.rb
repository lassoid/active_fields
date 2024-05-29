# frozen_string_literal: true

if ActiveFields.config.field_base_class_changed?
  RSpec.describe "ActiveFields::Field::Base" do
    it "is unavailable" do
      expect do
        ActiveFields::Field::Base
      end.to raise_error(NameError)
    end
  end
end
