# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ActiveFields::Finders::DecimalArrayFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  max_precision = ActiveFields::MAX_DECIMAL_PRECISION

  let!(:active_field) { create(:decimal_array_active_field, precision: precision) }
  let(:precision) { nil }
  let(:saved_value) { random_decimal(max_precision + 1) } # precision is greater than maximum allowed

  let!(:records) do
    calculated_precision = precision || max_precision
    minimum_delta = 10**-calculated_precision

    [
      [saved_value],
      [saved_value - minimum_delta],
      [saved_value + minimum_delta],

      [saved_value - rand(1..10)],
      [saved_value + rand(1..10)],

      [saved_value - minimum_delta, saved_value],
      [saved_value, saved_value + minimum_delta],

      [saved_value - rand(1..10), saved_value],
      [saved_value, saved_value + rand(1..10)],

      [saved_value - rand(1..10), saved_value + rand(1..10)],
      [],
    ].map do |value|
      create(active_value_factory, active_field: active_field, value: value)
    end
  end

  context "without precision" do
    context "with include operator" do
      let(:operator) { ["|=", :"|=", "include", :include].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.select { _1.value.include?(casted_value) })
            .and exclude(*records.reject { _1.value.include?(casted_value) })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with not_include operator" do
      let(:operator) { ["!|=", :"!|=", "not_include", :not_include].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that doesn't contain the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.reject { _1.value.include?(casted_value) })
            .and exclude(*records.select { _1.value.include?(casted_value) })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns all records" do
          expect(perform_search).to include(*records)
        end
      end
    end

    context "with any_gt operator" do
      let(:operator) { ["|>", :"|>", "any_gt", :any_gt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain an element greater than the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem > casted_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem > casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with any_gteq operator" do
      let(:operator) { ["|>=", :"|>=", "any_gteq", :any_gteq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain an element greater than or equal to the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem >= casted_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem >= casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with any_lt operator" do
      let(:operator) { ["|<", :"|<", "any_lt", :any_lt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain an element less than the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem < casted_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem < casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with any_lteq operator" do
      let(:operator) { ["|<=", :"|<=", "any_lteq", :any_lteq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain an element less than or equal to the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem <= casted_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem <= casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_gt operator" do
      let(:operator) { ["&>", :"&>", "all_gt", :all_gt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records where all elements are greater than the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem > casted_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem > casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_gteq operator" do
      let(:operator) { ["&>=", :"&>=", "all_gteq", :all_gteq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records where all elements are greater than or equal to the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem >= casted_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem >= casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_lt operator" do
      let(:operator) { ["&<", :"&<", "all_lt", :all_lt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records where all elements are less than the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem < casted_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem < casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_lteq operator" do
      let(:operator) { ["&<=", :"&<=", "all_lteq", :all_lteq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records where all elements are less than or equal to the value" do
          casted_value = saved_value.truncate(max_precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem <= casted_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem <= casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end
  end

  context "with precision" do
    let(:precision) { rand(0..max_precision) }

    context "with include operator" do
      let(:operator) { ["|=", :"|=", "include", :include].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.select { _1.value.include?(casted_value) })
            .and exclude(*records.reject { _1.value.include?(casted_value) })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with not_include operator" do
      let(:operator) { ["!|=", :"!|=", "not_include", :not_include].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that doesn't contain the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.reject { _1.value.include?(casted_value) })
            .and exclude(*records.select { _1.value.include?(casted_value) })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns all records" do
          expect(perform_search).to include(*records)
        end
      end
    end

    context "with any_gt operator" do
      let(:operator) { ["|>", :"|>", "any_gt", :any_gt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain an element greater than the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem > casted_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem > casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with any_gteq operator" do
      let(:operator) { ["|>=", :"|>=", "any_gteq", :any_gteq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain an element greater than or equal to the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem >= casted_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem >= casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with any_lt operator" do
      let(:operator) { ["|<", :"|<", "any_lt", :any_lt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain an element less than the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem < casted_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem < casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with any_lteq operator" do
      let(:operator) { ["|<=", :"|<=", "any_lteq", :any_lteq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records that contain an element less than or equal to the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem <= casted_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem <= casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_gt operator" do
      let(:operator) { ["&>", :"&>", "all_gt", :all_gt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records where all elements are greater than the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem > casted_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem > casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_gteq operator" do
      let(:operator) { ["&>=", :"&>=", "all_gteq", :all_gteq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records where all elements are greater than or equal to the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem >= casted_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem >= casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_lt operator" do
      let(:operator) { ["&<", :"&<", "all_lt", :all_lt].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records where all elements are less than the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem < casted_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem < casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_lteq operator" do
      let(:operator) { ["&<=", :"&<=", "all_lteq", :all_lteq].sample }

      context "when value is a decimal" do
        let(:value) { [saved_value, saved_value.to_s].sample }

        it "returns only records where all elements are less than or equal to the value" do
          casted_value = saved_value.truncate(precision)

          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem <= casted_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem <= casted_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end
  end

  include_examples "finder_array_size"

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
