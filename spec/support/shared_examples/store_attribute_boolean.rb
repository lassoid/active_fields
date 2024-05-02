# frozen_string_literal: true

RSpec.shared_examples "store_attribute_boolean" do |attr_name, store_attr_name, klass|
  describe "##{attr_name}" do
    subject(:call_method) { record.public_send(attr_name) }

    let(:record) { klass.new }

    before do
      record.public_send(store_attr_name)[attr_name.to_s] = internal_value
    end

    context "when internal value is false" do
      let(:internal_value) { [false, "false"].sample }

      it { is_expected.to be(false) }
    end

    context "when internal value is true" do
      let(:internal_value) { [true, "true"].sample }

      it { is_expected.to be(true) }
    end

    context "when internal value is nil" do
      let(:internal_value) { nil }

      it { is_expected.to be_nil }
    end

    context "when internal value is an empty string" do
      let(:internal_value) { "" }

      it { is_expected.to be_nil }
    end
  end

  describe "##{attr_name}?" do
    subject(:call_method) { record.public_send(:"#{attr_name}?") }

    let(:record) { klass.new }

    before do
      record.public_send(store_attr_name)[attr_name.to_s] = internal_value
    end

    context "when internal value is false" do
      let(:internal_value) { [false, "false"].sample }

      it { is_expected.to be(false) }
    end

    context "when internal value is true" do
      let(:internal_value) { [true, "true"].sample }

      it { is_expected.to be(true) }
    end

    context "when internal value is nil" do
      let(:internal_value) { nil }

      it { is_expected.to be(false) }
    end

    context "when internal value is an empty string" do
      let(:internal_value) { "" }

      it { is_expected.to be(false) }
    end
  end

  describe "##{attr_name}=" do
    subject(:call_method) { record.public_send(:"#{attr_name}=", value) }

    let(:record) { klass.new }

    context "when value is false" do
      let(:value) { [false, "false"].sample }

      it "sets false" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be(false)
      end
    end

    context "when value is true" do
      let(:value) { [true, "true"].sample }

      it "sets true" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be(true)
      end
    end

    context "when value is nil" do
      let(:value) { nil }

      it "sets nil" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be_nil
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "sets nil" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be_nil
      end
    end
  end
end
