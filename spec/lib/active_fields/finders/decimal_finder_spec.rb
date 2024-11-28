# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ActiveFields::Finders::DecimalFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  max_precision = ActiveFields::MAX_DECIMAL_PRECISION

  let!(:active_field) { create(:decimal_active_field, precision: precision) }
  let(:precision) { nil }
  let(:saved_value) { random_decimal(max_precision + 1) } # precision is greater than maximum allowed

  let!(:records) do
    calculated_precision = precision || max_precision
    minimum_delta = 10**-calculated_precision

    [
      create(active_value_factory, active_field: active_field, value: saved_value),
      create(active_value_factory, active_field: active_field, value: saved_value - minimum_delta),
      create(active_value_factory, active_field: active_field, value: saved_value + minimum_delta),
      create(active_value_factory, active_field: active_field, value: saved_value - 1),
      create(active_value_factory, active_field: active_field, value: saved_value + 1),
      create(active_value_factory, active_field: active_field, value: nil),
    ]
  end

  context "without precision" do
    context "with eq operator" do
      let(:operator) { ["=", :"=", "eq", :eq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value == saved_value.truncate(max_precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value == saved_value.truncate(max_precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to include(*records.select { _1.value.nil? }) }
        it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
      end
    end

    context "with not_eq operator" do
      let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.reject { _1.value == saved_value.truncate(max_precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.select { _1.value == saved_value.truncate(max_precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to include(*records.reject { _1.value.nil? }) }
        it { is_expected.to exclude(*records.select { _1.value.nil? }) }
      end
    end

    context "with gt operator" do
      let(:operator) { [">", :">", "gt", :gt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value && _1.value > saved_value.truncate(max_precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value && _1.value > saved_value.truncate(max_precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to exclude(*records) }
      end
    end

    context "with gteq operator" do
      let(:operator) { [">=", :">=", "gteq", :gteq, "gte", :gte].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value && _1.value >= saved_value.truncate(max_precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value && _1.value >= saved_value.truncate(max_precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to exclude(*records) }
      end
    end

    context "with lt operator" do
      let(:operator) { ["<", :"<", "lt", :lt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value && _1.value < saved_value.truncate(max_precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value && _1.value < saved_value.truncate(max_precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to exclude(*records) }
      end
    end

    context "with lteq operator" do
      let(:operator) { ["<=", :"<=", "lteq", :lteq, "lte", :lte].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value && _1.value <= saved_value.truncate(max_precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value && _1.value <= saved_value.truncate(max_precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to exclude(*records) }
      end
    end
  end

  context "with precision" do
    let(:precision) { rand(0..max_precision) }

    context "with eq operator" do
      let(:operator) { ["=", :"=", "eq", :eq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value == saved_value.truncate(precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value == saved_value.truncate(precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to include(*records.select { _1.value.nil? }) }
        it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
      end
    end

    context "with not_eq operator" do
      let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.reject { _1.value == saved_value.truncate(precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.select { _1.value == saved_value.truncate(precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to include(*records.reject { _1.value.nil? }) }
        it { is_expected.to exclude(*records.select { _1.value.nil? }) }
      end
    end

    context "with gt operator" do
      let(:operator) { [">", :">", "gt", :gt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value && _1.value > saved_value.truncate(precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value && _1.value > saved_value.truncate(precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to exclude(*records) }
      end
    end

    context "with gteq operator" do
      let(:operator) { [">=", :">=", "gteq", :gteq, "gte", :gte].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value && _1.value >= saved_value.truncate(precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value && _1.value >= saved_value.truncate(precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to exclude(*records) }
      end
    end

    context "with lt operator" do
      let(:operator) { ["<", :"<", "lt", :lt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value && _1.value < saved_value.truncate(precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value && _1.value < saved_value.truncate(precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to exclude(*records) }
      end
    end

    context "with lteq operator" do
      let(:operator) { ["<=", :"<=", "lteq", :lteq, "lte", :lte].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it do
          expect(perform_search).to include(
            *records.select { _1.value && _1.value <= saved_value.truncate(precision) },
          )
        end

        it do
          expect(perform_search).to exclude(
            *records.reject { _1.value && _1.value <= saved_value.truncate(precision) },
          )
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it { is_expected.to exclude(*records) }
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
# rubocop:enable RSpec/MultipleMemoizedHelpers
