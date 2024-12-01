# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::TextFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:text_active_field) }
  let(:saved_value) { random_string }

  let!(:records) do
    [
      saved_value,
      saved_value.swapcase,
      "start_#{saved_value}",
      "start_#{saved_value}".swapcase,
      "#{saved_value}_end",
      "#{saved_value}_end".swapcase,
      "start_#{saved_value}_end",
      "start_#{saved_value}_end".swapcase,
      random_string,
      "",
      " ",
      nil,
    ].map do |value|
      create(active_value_factory, active_field: active_field, value: value)
    end
  end

  context "with eq operator" do
    let(:operator) { ["=", :"=", "eq", :eq].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it "returns only records with such value" do
        expect(perform_search)
          .to include(*records.select { _1.value == value })
          .and exclude(*records.reject { _1.value == value })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with such value" do
        expect(perform_search)
          .to include(*records.select { _1.value == value })
          .and exclude(*records.reject { _1.value == value })
      end
    end

    context "when value is nil" do
      let(:value) { nil }

      it "returns only records with null value" do
        expect(perform_search)
          .to include(*records.select { _1.value.nil? })
          .and exclude(*records.reject { _1.value.nil? })
      end
    end
  end

  context "with not_eq operator" do
    let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it "returns all records except with such value" do
        expect(perform_search)
          .to include(*records.reject { _1.value == value })
          .and exclude(*records.select { _1.value == value })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns all records except with such value" do
        expect(perform_search)
          .to include(*records.reject { _1.value == value })
          .and exclude(*records.select { _1.value == value })
      end
    end

    context "when value is nil" do
      let(:value) { nil }

      it "returns only records with not null value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.nil? })
          .and exclude(*records.select { _1.value.nil? })
      end
    end
  end

  context "with start_with operator" do
    let(:operator) { ["^", :"^", "start_with", :start_with].sample }

    context "when value is a string" do
      let(:value) { "start_" }

      it "returns records that start with the value" do
        expect(perform_search)
          .to include(*records.select { _1.value&.start_with?(value) })
          .and exclude(*records.reject { _1.value&.start_with?(value) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with not null value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.nil? })
          .and exclude(*records.select { _1.value.nil? })
      end
    end
  end

  context "with end_with operator" do
    let(:operator) { ["$", :"$", "end_with", :end_with].sample }

    context "when value is a string" do
      let(:value) { "_end" }

      it "returns records that end with the value" do
        expect(perform_search)
          .to include(*records.select { _1.value&.end_with?(value) })
          .and exclude(*records.reject { _1.value&.end_with?(value) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with not null value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.nil? })
          .and exclude(*records.select { _1.value.nil? })
      end
    end
  end

  context "with contain operator" do
    let(:operator) { ["~", :"~", "contain", :contain].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it "returns records that contain the value" do
        expect(perform_search)
          .to include(*records.select { _1.value&.include?(value) })
          .and exclude(*records.reject { _1.value&.include?(value) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with not null value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.nil? })
          .and exclude(*records.select { _1.value.nil? })
      end
    end
  end

  context "with not_start_with operator" do
    let(:operator) { ["!^", :"!^", "not_start_with", :not_start_with].sample }

    context "when value is a string" do
      let(:value) { "start_" }

      it "returns records that don't start with the value" do
        expect(perform_search)
          .to include(*records.reject { _1.value&.start_with?(value) })
          .and exclude(*records.select { _1.value&.start_with?(value) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with null value" do
        expect(perform_search)
          .to include(*records.select { _1.value.nil? })
          .and exclude(*records.reject { _1.value.nil? })
      end
    end
  end

  context "with not_end_with operator" do
    let(:operator) { ["!$", :"!$", "not_end_with", :not_end_with].sample }

    context "when value is a string" do
      let(:value) { "_end" }

      it "returns records that don't end with the value" do
        expect(perform_search)
          .to include(*records.reject { _1.value&.end_with?(value) })
          .and exclude(*records.select { _1.value&.end_with?(value) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with null value" do
        expect(perform_search)
          .to include(*records.select { _1.value.nil? })
          .and exclude(*records.reject { _1.value.nil? })
      end
    end
  end

  context "with not_contain operator" do
    let(:operator) { ["!~", :"!~", "not_contain", :not_contain].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it "returns records that don't contain with the value" do
        expect(perform_search)
          .to include(*records.reject { _1.value&.include?(value) })
          .and exclude(*records.select { _1.value&.include?(value) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with null value" do
        expect(perform_search)
          .to include(*records.select { _1.value.nil? })
          .and exclude(*records.reject { _1.value.nil? })
      end
    end
  end

  context "with istart_with operator" do
    let(:operator) { ["^*", :"^*", "istart_with", :istart_with].sample }

    context "when value is a string" do
      let(:value) { "sTaRt_" }

      it "returns records that insensitively start with the value" do
        expect(perform_search)
          .to include(*records.select { _1.value&.downcase&.start_with?(value.downcase) })
          .and exclude(*records.reject { _1.value&.downcase&.start_with?(value.downcase) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with not null value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.nil? })
          .and exclude(*records.select { _1.value.nil? })
      end
    end
  end

  context "with iend_with operator" do
    let(:operator) { ["$*", :"$*", "iend_with", :iend_with].sample }

    context "when value is a string" do
      let(:value) { "_EnD" }

      it "returns records that insensitively end with the value" do
        expect(perform_search)
          .to include(*records.select { _1.value&.downcase&.end_with?(value.downcase) })
          .and exclude(*records.reject { _1.value&.downcase&.end_with?(value.downcase) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with not null value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.nil? })
          .and exclude(*records.select { _1.value.nil? })
      end
    end
  end

  context "with icontain operator" do
    let(:operator) { ["~*", :"~*", "icontain", :icontain].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it "returns records that insensitively contain with the value" do
        expect(perform_search)
          .to include(*records.select { _1.value&.downcase&.include?(value.downcase) })
          .and exclude(*records.reject { _1.value&.downcase&.include?(value.downcase) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with not null value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.nil? })
          .and exclude(*records.select { _1.value.nil? })
      end
    end
  end

  context "with not_istart_with operator" do
    let(:operator) { ["!^*", :"!^*", "not_istart_with", :not_istart_with].sample }

    context "when value is a string" do
      let(:value) { "StArT_" }

      it "returns records that don't insensitively start with the value" do
        expect(perform_search)
          .to include(*records.reject { _1.value&.downcase&.start_with?(value.downcase) })
          .and exclude(*records.select { _1.value&.downcase&.start_with?(value.downcase) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with null value" do
        expect(perform_search)
          .to include(*records.select { _1.value.nil? })
          .and exclude(*records.reject { _1.value.nil? })
      end
    end
  end

  context "with not_iend_with operator" do
    let(:operator) { ["!$*", :"!$*", "not_iend_with", :not_iend_with].sample }

    context "when value is a string" do
      let(:value) { "_eNd" }

      it "returns records that don't insensitively end with the value" do
        expect(perform_search)
          .to include(*records.reject { _1.value&.downcase&.end_with?(value.downcase) })
          .and exclude(*records.select { _1.value&.downcase&.end_with?(value.downcase) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with null value" do
        expect(perform_search)
          .to include(*records.select { _1.value.nil? })
          .and exclude(*records.reject { _1.value.nil? })
      end
    end
  end

  context "with not_icontain operator" do
    let(:operator) { ["!~*", :"!~*", "not_icontain", :not_icontain].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it "returns records that don't insensitively contain with the value" do
        expect(perform_search)
          .to include(*records.reject { _1.value&.downcase&.include?(value.downcase) })
                .and exclude(*records.select { _1.value&.downcase&.include?(value.downcase) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records with null value" do
        expect(perform_search)
          .to include(*records.select { _1.value.nil? })
          .and exclude(*records.reject { _1.value.nil? })
      end
    end
  end

  context "with invalid operator" do
    let(:operator) { "invalid" }
    let(:value) { nil }

    it "raises an error" do
      expect do
        perform_search
      end.to raise_error(ArgumentError)
    end
  end
end
