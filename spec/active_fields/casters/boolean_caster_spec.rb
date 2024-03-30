# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::BooleanCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when falsy value" do
      let(:value) { [0, "0", "false", "f", false].sample }

      it { is_expected.to be(false) }
    end

    context "when truthy value" do
      let(:value) { [1, "1", "true", "t", true].sample }

      it { is_expected.to be(true) }
    end

    context "when nil value" do
      let(:value) { ["", nil].sample }

      it { is_expected.to be_nil }
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    let(:object) { described_class.new }

    context "when falsy value" do
      let(:value) { [0, "0", "false", "f", false].sample }

      it { is_expected.to be(false) }
    end

    context "when truthy value" do
      let(:value) { [1, "1", "true", "t", true].sample }

      it { is_expected.to be(true) }
    end

    context "when nil value" do
      let(:value) { ["", nil].sample }

      it { is_expected.to be_nil }
    end
  end
end
