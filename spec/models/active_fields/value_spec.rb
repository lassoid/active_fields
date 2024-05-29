# frozen_string_literal: true

if ActiveFields.config.value_class_changed?
  RSpec.describe "ActiveFields::Value" do
    it "is unavailable" do
      expect do
        ActiveFields::Value
      end.to raise_error(NameError)
    end
  end
else
  RSpec.describe ActiveFields::Value do
    factory = :active_value

    it_behaves_like "active_value",
      factory: factory

    it "has a valid factory" do
      expect(build(factory)).to be_valid
    end
  end
end
