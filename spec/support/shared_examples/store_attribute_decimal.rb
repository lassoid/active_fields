# frozen_string_literal: true

RSpec.shared_examples "store_attribute_decimal" do |attr_name, store_attr_name, klass|
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

    context "when internal value is an integer" do
      let(:internal_value) { rand(-10..10) }

      it { is_expected.to eq(internal_value.to_d) }
    end

    context "when internal value is a float" do
      let(:internal_value) { rand(-10.0..10.0) }

      it { is_expected.to eq(internal_value.to_d) }
    end

    context "when internal value is a big decimal" do
      let(:internal_value) { rand(-10.0..10.0).to_d }

      it { is_expected.to eq(internal_value) }
    end

    context "when internal value is an integer string" do
      let(:internal_value) { rand(-10..10).to_s }

      it { is_expected.to eq(internal_value.to_d) }
    end

    context "when internal value is decimal string" do
      let(:internal_value) { rand(-10.0..10.0).to_s }

      it { is_expected.to eq(internal_value.to_d) }
    end

    context "when internal value is invalid" do
      let(:internal_value) { "#{rand(-10..10)} not a number #{rand(-10..10)}" }

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

    context "when value is an integer" do
      let(:value) { rand(-10..10) }

      it "sets decimal" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value.to_d)
      end
    end

    context "when value is a float" do
      let(:value) { rand(-10.0..10.0) }

      it "sets decimal" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value.to_d)
      end
    end

    context "when value is a big decimal" do
      let(:value) { rand(-10.0..10.0).to_d }

      it "sets decimal" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value)
      end
    end

    context "when value is an integer string" do
      let(:value) { rand(-10..10).to_s }

      it "sets decimal" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value.to_d)
      end
    end

    context "when value is decimal string" do
      let(:value) { rand(-10.0..10.0).to_s }

      it "sets decimal" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to eq(value.to_d)
      end
    end

    context "when value is an invalid string" do
      let(:value) { "#{rand(-10..10)} not a number #{rand(-10..10)}" }

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
