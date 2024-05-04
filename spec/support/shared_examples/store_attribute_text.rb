# frozen_string_literal: true

RSpec.shared_examples "store_attribute_text" do |attr_name, store_attr_name, klass|
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

    context "when internal value is a number" do
      let(:internal_value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d].sample }

      it { is_expected.to eq(internal_value.to_s) }
    end

    context "when internal value is a date" do
      let(:internal_value) { Date.today + rand(-10..10) }

      it { is_expected.to eq(internal_value.to_s) }
    end

    context "when internal value is a string" do
      let(:internal_value) { random_string(10) }

      it { is_expected.to eq(internal_value) }
    end

    context "when internal value is an empty string" do
      let(:internal_value) { "" }

      it { is_expected.to eq(internal_value) }
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

    context "when value is a number" do
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d].sample }

      it "sets string" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value.to_s)
      end
    end

    context "when value is a date" do
      let(:value) { Date.today + rand(-10..10) }

      it "sets string" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value.to_s)
      end
    end

    context "when value is a string" do
      let(:value) { random_string(10) }

      it "sets string" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value)
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "sets string" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value)
      end
    end
  end
end
