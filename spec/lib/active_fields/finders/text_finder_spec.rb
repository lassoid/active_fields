# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::TextFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:text_active_field) }
  let(:saved_value) { random_string }

  let!(:records) do
    [
      create(active_value_factory, active_field: active_field, value: saved_value),
      create(active_value_factory, active_field: active_field, value: saved_value.swapcase),
      create(active_value_factory, active_field: active_field, value: "start_#{saved_value}"),
      create(active_value_factory, active_field: active_field, value: "start_#{saved_value}".swapcase),
      create(active_value_factory, active_field: active_field, value: "#{saved_value}_end"),
      create(active_value_factory, active_field: active_field, value: "#{saved_value}_end".swapcase),
      create(active_value_factory, active_field: active_field, value: "start_#{saved_value}_end"),
      create(active_value_factory, active_field: active_field, value: "start_#{saved_value}_end".swapcase),
      create(active_value_factory, active_field: active_field, value: random_string),
      create(active_value_factory, active_field: active_field, value: ""),
      create(active_value_factory, active_field: active_field, value: nil),
    ]
  end

  context "with eq operator" do
    let(:operator) { ["=", :"=", "eq", :eq].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.select { _1.value == value }) }
      it { is_expected.to exclude(*records.reject { _1.value == value }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value == value }) }
      it { is_expected.to exclude(*records.reject { _1.value == value }) }
    end

    context "when value is nil" do
      let(:value) { nil }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end
  end

  context "with not_eq operator" do
    let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.reject { _1.value == value }) }
      it { is_expected.to exclude(*records.select { _1.value == value }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value == value }) }
      it { is_expected.to exclude(*records.select { _1.value == value }) }
    end

    context "when value is nil" do
      let(:value) { nil }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end
  end

  # TODO: fix invalid pattern errors for like/ilike/not_like/not_ilike
  # Maybe remove raw like and ilike operators?
  # It looks unsafe: user can provide an invalid pattern and the request will fail
  # bin/rspec spec/lib/active_fields/finders/text_finder_spec.rb --seed 14644
  context "with like operator" do
    let(:operator) { ["~~", :"~~", "like", :like].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.select { _1.value == value }) }
      it { is_expected.to exclude(*records.reject { _1.value == value }) }
    end

    context "when value is a % pattern string" do
      let(:value) { "%#{saved_value[2..-3]}%" }

      it { is_expected.to include(*records.select { _1.value =~ /\A.*#{Regexp.escape(saved_value[2..-3])}.*\z/ }) }
      it { is_expected.to exclude(*records.reject { _1.value =~ /\A.*#{Regexp.escape(saved_value[2..-3])}.*\z/ }) }
    end

    context "when value is a _ pattern string" do
      let(:value) { "_#{saved_value[1..-2]}_" }

      it { is_expected.to include(*records.select { _1.value =~ /\A.#{Regexp.escape(saved_value[1..-2])}.\z/ }) }
      it { is_expected.to exclude(*records.reject { _1.value =~ /\A.#{Regexp.escape(saved_value[1..-2])}.\z/ }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value == value }) }
      it { is_expected.to exclude(*records.reject { _1.value == value }) }
    end
  end

  context "with ilike operator" do
    let(:operator) { ["~~*", :"~~*", "ilike", :ilike].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.select { _1.value&.downcase == value.downcase }) }
      it { is_expected.to exclude(*records.reject { _1.value&.downcase == value.downcase }) }
    end

    context "when value is a % pattern string" do
      let(:value) { "%#{saved_value[2..-3]}%" }

      it { is_expected.to include(*records.select { _1.value =~ /\A.*#{Regexp.escape(saved_value[2..-3])}.*\z/i }) }
      it { is_expected.to exclude(*records.reject { _1.value =~ /\A.*#{Regexp.escape(saved_value[2..-3])}.*\z/i }) }
    end

    context "when value is a _ pattern string" do
      let(:value) { "_#{saved_value[1..-2]}_" }

      it { is_expected.to include(*records.select { _1.value =~ /\A.#{Regexp.escape(saved_value[1..-2])}.\z/i }) }
      it { is_expected.to exclude(*records.reject { _1.value =~ /\A.#{Regexp.escape(saved_value[1..-2])}.\z/i }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value == value }) }
      it { is_expected.to exclude(*records.reject { _1.value == value }) }
    end
  end

  context "with not_like operator" do
    let(:operator) { ["!~~", :"!~~", "not_like", :not_like].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.reject { _1.value == value }) }
      it { is_expected.to exclude(*records.select { _1.value == value }) }
    end

    context "when value is a % pattern string" do
      let(:value) { "%#{saved_value[2..-3]}%" }

      it { is_expected.to include(*records.reject { _1.value =~ /\A.*#{Regexp.escape(saved_value[2..-3])}.*\z/ }) }
      it { is_expected.to exclude(*records.select { _1.value =~ /\A.*#{Regexp.escape(saved_value[2..-3])}.*\z/ }) }
    end

    context "when value is a _ pattern string" do
      let(:value) { "_#{saved_value[1..-2]}_" }

      it { is_expected.to include(*records.reject { _1.value =~ /\A.#{Regexp.escape(saved_value[1..-2])}.\z/ }) }
      it { is_expected.to exclude(*records.select { _1.value =~ /\A.#{Regexp.escape(saved_value[1..-2])}.\z/ }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value == value }) }
      it { is_expected.to exclude(*records.select { _1.value == value }) }
    end
  end

  context "with not_ilike operator" do
    let(:operator) { ["!~~*", :"!~~*", "not_ilike", :not_ilike].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.reject { _1.value&.downcase == value.downcase }) }
      it { is_expected.to exclude(*records.select { _1.value&.downcase == value.downcase }) }
    end

    context "when value is a % pattern string" do
      let(:value) { "%#{saved_value[2..-3]}%" }

      it { is_expected.to include(*records.reject { _1.value =~ /\A.*#{Regexp.escape(saved_value[2..-3])}.*\z/i }) }
      it { is_expected.to exclude(*records.select { _1.value =~ /\A.*#{Regexp.escape(saved_value[2..-3])}.*\z/i }) }
    end

    context "when value is a _ pattern string" do
      let(:value) { "_#{saved_value[1..-2]}_" }

      it { is_expected.to include(*records.reject { _1.value =~ /\A.#{Regexp.escape(saved_value[1..-2])}.\z/i }) }
      it { is_expected.to exclude(*records.select { _1.value =~ /\A.#{Regexp.escape(saved_value[1..-2])}.\z/i }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value == value }) }
      it { is_expected.to exclude(*records.select { _1.value == value }) }
    end
  end

  context "with start_with operator" do
    let(:operator) { ["^", :"^", "start_with", :start_with].sample }

    context "when value is a string" do
      let(:value) { "start_" }

      it { is_expected.to include(*records.select { _1.value&.start_with?(value) }) }
      it { is_expected.to exclude(*records.reject { _1.value&.start_with?(value) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end
  end

  context "with end_with operator" do
    let(:operator) { ["$", :"$", "end_with", :end_with].sample }

    context "when value is a string" do
      let(:value) { "_end" }

      it { is_expected.to include(*records.select { _1.value&.end_with?(value) }) }
      it { is_expected.to exclude(*records.reject { _1.value&.end_with?(value) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end
  end

  context "with contain operator" do
    let(:operator) { ["~", :"~", "contain", :contain].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.select { _1.value&.include?(value) }) }
      it { is_expected.to exclude(*records.reject { _1.value&.include?(value) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end
  end

  context "with not_start_with operator" do
    let(:operator) { ["!^", :"!^", "not_start_with", :not_start_with].sample }

    context "when value is a string" do
      let(:value) { "start_" }

      it { is_expected.to include(*records.reject { _1.value&.start_with?(value) }) }
      it { is_expected.to exclude(*records.select { _1.value&.start_with?(value) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end
  end

  context "with not_end_with operator" do
    let(:operator) { ["!$", :"!$", "not_end_with", :not_end_with].sample }

    context "when value is a string" do
      let(:value) { "_end" }

      it { is_expected.to include(*records.reject { _1.value&.end_with?(value) }) }
      it { is_expected.to exclude(*records.select { _1.value&.end_with?(value) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end
  end

  context "with not_contain operator" do
    let(:operator) { ["!~", :"!~", "not_contain", :not_contain].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.reject { _1.value&.include?(value) }) }
      it { is_expected.to exclude(*records.select { _1.value&.include?(value) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end
  end

  context "with istart_with operator" do
    let(:operator) { ["^*", :"^*", "istart_with", :istart_with].sample }

    context "when value is a string" do
      let(:value) { "sTaRt_" }

      it { is_expected.to include(*records.select { _1.value&.downcase&.start_with?(value.downcase) }) }
      it { is_expected.to exclude(*records.reject { _1.value&.downcase&.start_with?(value.downcase) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end
  end

  context "with iend_with operator" do
    let(:operator) { ["$*", :"$*", "iend_with", :iend_with].sample }

    context "when value is a string" do
      let(:value) { "_EnD" }

      it { is_expected.to include(*records.select { _1.value&.downcase&.end_with?(value.downcase) }) }
      it { is_expected.to exclude(*records.reject { _1.value&.downcase&.end_with?(value.downcase) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end
  end

  context "with icontain operator" do
    let(:operator) { ["~*", :"~*", "icontain", :icontain].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.select { _1.value&.downcase&.include?(value.downcase) }) }
      it { is_expected.to exclude(*records.reject { _1.value&.downcase&.include?(value.downcase) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end
  end

  context "with not_istart_with operator" do
    let(:operator) { ["!^*", :"!^*", "not_istart_with", :not_istart_with].sample }

    context "when value is a string" do
      let(:value) { "StArT_" }

      it { is_expected.to include(*records.reject { _1.value&.downcase&.start_with?(value.downcase) }) }
      it { is_expected.to exclude(*records.select { _1.value&.downcase&.start_with?(value.downcase) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end
  end

  context "with not_iend_with operator" do
    let(:operator) { ["!$*", :"!$*", "not_iend_with", :not_iend_with].sample }

    context "when value is a string" do
      let(:value) { "_eNd" }

      it { is_expected.to include(*records.reject { _1.value&.downcase&.end_with?(value.downcase) }) }
      it { is_expected.to exclude(*records.select { _1.value&.downcase&.end_with?(value.downcase) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end
  end

  context "with not_icontain operator" do
    let(:operator) { ["!~*", :"!~*", "not_icontain", :not_icontain].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.reject { _1.value&.downcase&.include?(value.downcase) }) }
      it { is_expected.to exclude(*records.select { _1.value&.downcase&.include?(value.downcase) }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
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
