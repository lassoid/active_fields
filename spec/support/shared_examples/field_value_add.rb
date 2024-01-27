# frozen_string_literal: true

RSpec.shared_examples "field_value_add" do |factory, *traits|
  context "[#{traits.join(", ")}]" do
    subject(:create_field) { record.save! }

    let!(:customizable) { Post.create! }

    let(:record) { build(factory, *traits, customizable_type: customizable.class.name) }

    it "creates active_value for customizable" do
      expect do
        create_field
        customizable.reload
      end.to change { customizable.active_values.size }.by(1)
    end

    it "sets active_value value" do
      create_field
      customizable.reload

      expect(customizable.active_values.take!.value).to eq(record.default_value)
    end
  end
end
