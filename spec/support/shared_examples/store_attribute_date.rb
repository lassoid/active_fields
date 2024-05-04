# frozen_string_literal: true

RSpec.shared_examples "store_attribute_date" do |attr_name, store_attr_name, klass|
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

    context "when internal value is a date" do
      let(:internal_value) { random_date }

      it { is_expected.to eq(internal_value) }
    end

    context "when internal value is a date string" do
      let(:internal_value) { random_date.iso8601 }

      it { is_expected.to eq(Date.parse(internal_value)) }
    end

    context "when internal value is a number" do
      let(:internal_value) { random_number }

      it { is_expected.to be_nil }
    end

    context "when internal value is an invalid string" do
      let(:internal_value) { "not a date" }

      it { is_expected.to be_nil }
    end

    context "when internal value is an empty string" do
      let(:internal_value) { "" }

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

    context "when value is a date" do
      let(:value) { random_date }

      it "sets date as string" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value.iso8601)
      end
    end

    context "when value is a date string" do
      let(:value) { random_date.iso8601 }

      it "sets date as string" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value)
      end
    end

    context "when value is a number" do
      let(:value) { random_number }

      it "sets nil" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be_nil
      end
    end

    context "when value is an invalid string" do
      let(:value) { "not a date" }

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
