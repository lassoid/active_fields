# frozen_string_literal: true

RSpec.shared_examples "store_attribute_text_array" do |attr_name, store_attr_name, klass|
  describe "##{attr_name}" do
    subject(:call_method) { record.public_send(attr_name) }

    let(:record) { klass.new }

    before do
      record.public_send(store_attr_name)[attr_name.to_s] = internal_value
    end

    context "when internal value is nil" do
      let(:internal_value) { nil }

      it { is_expected.to be_nil }
    end

    context "when internal value is an array of nils" do
      let(:internal_value) { [nil, nil] }

      it { is_expected.to eq(internal_value) }
    end

    context "when internal value is an array of numbers" do
      let(:internal_value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d] }

      it { is_expected.to eq(internal_value.map(&:to_s)) }
    end

    context "when internal value is an array of strings" do
      let(:internal_value) { ["", random_string(10)] }

      it { is_expected.to eq(internal_value) }
    end

    context "when internal value is not an array" do
      let(:internal_value) { random_string(10) }

      it { is_expected.to be_nil }
    end
  end

  describe "##{attr_name}=" do
    subject(:call_method) { record.public_send(:"#{attr_name}=", value) }

    let(:record) { klass.new }

    context "when value is nil" do
      let(:value) { nil }

      it "sets nil" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be_nil
      end
    end

    context "when value is an array of nils" do
      let(:value) { [nil, nil] }

      it "sets array of nils" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value)
      end
    end

    context "when value is an array of numbers" do
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d] }

      it "sets array of strings" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value.map(&:to_s))
      end
    end

    context "when value is an array of strings" do
      let(:value) { ["", random_string(10)] }

      it "sets array of strings" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value)
      end
    end

    context "when value is not an array" do
      let(:value) { random_string(10) }

      it "sets nil" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be_nil
      end
    end
  end
end
