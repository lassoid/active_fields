# frozen_string_literal: true

RSpec.shared_examples "field_value_validate" do |value_proc, label, errors_proc = -> { [] }|
  context "when value is #{label}" do
    let(:value) { instance_exec(&value_proc) }
    let(:errors) { instance_exec(&errors_proc) }

    it { is_expected.to be(errors.empty?) }

    it "returns validation result" do
      validate

      expect(object.valid?).to be(errors.empty?)
    end

    it "returns validation errors" do
      validate

      expect(object.errors).to match_array(errors)
    end
  end
end
