# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DecimalArrayCaster do
  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when array of nils" do
      let(:value) { [nil, nil] }

      it { is_expected.to eq(value) }
    end

    context "when array of invalid strings" do
      let(:value) { ["", "#{random_number} not a number #{random_number}"] }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of numbers" do
      let(:value) { random_numbers }

      it { is_expected.to eq(value.map { _1.to_d.to_s }) }
    end

    context "when array of number strings" do
      let(:value) { [random_integer.to_s, random_float.to_s] }

      it { is_expected.to eq(value.map { _1.to_d.to_s }) }
    end

    context "when not an array" do
      let(:value) { [random_integer.to_s, random_float.to_s, *random_numbers].sample }

      it { is_expected.to be_nil }
    end

    context "with precision" do
      let(:args) { { precision: rand(0..10) } }

      context "when array of numbers" do
        let(:value) { random_numbers }

        it { is_expected.to eq(value.map { _1.to_d.truncate(args[:precision]).to_s }) }
      end

      context "when array of number strings" do
        let(:value) { [random_integer.to_s, random_float.to_s] }

        it { is_expected.to eq(value.map { _1.to_d.truncate(args[:precision]).to_s }) }
      end
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when array of nils" do
      let(:value) { [nil, nil] }

      it { is_expected.to eq(value) }
    end

    context "when array of invalid strings" do
      let(:value) { ["", "#{random_number} not a number #{random_number}"] }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of numbers" do
      let(:value) { random_numbers }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when array of number strings" do
      let(:value) { [random_integer.to_s, random_float.to_s] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when not an array" do
      let(:value) { [random_integer.to_s, random_float.to_s, *random_numbers].sample }

      it { is_expected.to be_nil }
    end

    context "with precision" do
      let(:args) { { precision: rand(0..10) } }

      context "when array of numbers" do
        let(:value) { random_numbers }

        it { is_expected.to eq(value.map { _1.to_d.truncate(args[:precision]) }) }
      end

      context "when array of number strings" do
        let(:value) { [random_integer.to_s, random_float.to_s] }

        it { is_expected.to eq(value.map { _1.to_d.truncate(args[:precision]) }) }
      end
    end
  end
end
