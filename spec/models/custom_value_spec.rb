# frozen_string_literal: true

if ActiveFields.config.value_class_changed?
  RSpec.describe CustomValue do
    def factory = :custom_value

    it_behaves_like "active_value", factory: factory

    it "has a valid factory" do
      expect(build(factory)).to be_valid
    end
  end
end
