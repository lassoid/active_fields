# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DecimalCaster do
  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when integer" do
      let(:value) { random_integer }

      it { is_expected.to eq(value.to_d.to_s) }
    end

    context "when float" do
      let(:value) { random_float }

      it { is_expected.to eq(value.to_d.to_s) }
    end

    context "when big decimal" do
      let(:value) { random_decimal }

      it { is_expected.to eq(value.to_s) }
    end

    context "when integer string" do
      let(:value) { random_integer.to_s }

      it { is_expected.to eq(value.to_d.to_s) }
    end

    context "when decimal string" do
      let(:value) { random_float.to_s }

      it { is_expected.to eq(value.to_d.to_s) }
    end

    context "when invalid string" do
      let(:value) { "#{random_number} not a number #{random_number}" }

      it { is_expected.to be_nil }
    end

    context "when empty string" do
      let(:value) { "" }

      it { is_expected.to be_nil }
    end

    context "with precision" do
      let(:args) { { precision: rand(0..10) } }

      context "when integer" do
        let(:value) { random_integer }

        it { is_expected.to eq(value.to_d.truncate(args[:precision]).to_s) }
      end

      context "when float" do
        let(:value) { random_float }

        it { is_expected.to eq(value.to_d.truncate(args[:precision]).to_s) }
      end

      context "when big decimal" do
        let(:value) { random_decimal }

        it { is_expected.to eq(value.truncate(args[:precision]).to_s) }
      end

      context "when integer string" do
        let(:value) { random_integer.to_s }

        it { is_expected.to eq(value.to_d.truncate(args[:precision]).to_s) }
      end

      context "when decimal string" do
        let(:value) { random_float.to_s }

        it { is_expected.to eq(value.to_d.truncate(args[:precision]).to_s) }
      end
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when integer" do
      let(:value) { random_integer }

      it { is_expected.to eq(value.to_d) }
    end

    context "when float" do
      let(:value) { random_float }

      it { is_expected.to eq(value.to_d) }
    end

    context "when big decimal" do
      let(:value) { random_decimal }

      it { is_expected.to eq(value) }
    end

    context "when integer string" do
      let(:value) { random_integer.to_s }

      it { is_expected.to eq(value.to_d) }
    end

    context "when decimal string" do
      let(:value) { random_float.to_s }

      it { is_expected.to eq(value.to_d) }
    end

    context "when invalid string" do
      let(:value) { "#{random_number} not a number #{random_number}" }

      it { is_expected.to be_nil }
    end

    context "when empty string" do
      let(:value) { "" }

      it { is_expected.to be_nil }
    end

    context "with precision" do
      let(:args) { { precision: rand(0..10) } }

      context "when integer" do
        let(:value) { random_integer }

        it { is_expected.to eq(value.to_d.truncate(args[:precision])) }
      end

      context "when float" do
        let(:value) { random_float }

        it { is_expected.to eq(value.to_d.truncate(args[:precision])) }
      end

      context "when big decimal" do
        let(:value) { random_decimal }

        it { is_expected.to eq(value.truncate(args[:precision])) }
      end

      context "when integer string" do
        let(:value) { random_integer.to_s }

        it { is_expected.to eq(value.to_d.truncate(args[:precision])) }
      end

      context "when decimal string" do
        let(:value) { random_float.to_s }

        it { is_expected.to eq(value.to_d.truncate(args[:precision])) }
      end
    end
  end
end
