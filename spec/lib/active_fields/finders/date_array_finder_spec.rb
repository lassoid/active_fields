# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::DateArrayFinder do
  it_behaves_like "field_finder"

  describe "#search" do
    subject(:perform_search) do
      described_class.new(active_field: active_field).search(op: op, value: value)
    end

    let!(:active_field) { create(:date_array_active_field) }
    let(:saved_value) { random_date }

    let!(:records) do
      [
        [saved_value],
        [rand(1..10).days.before(saved_value)],
        [rand(1..10).days.after(saved_value)],
        [rand(1..10).days.before(saved_value), saved_value],
        [saved_value, rand(1..10).days.after(saved_value)],
        [rand(1..10).days.before(saved_value), rand(1..10).days.after(saved_value)],
        [],
      ].map do |value|
        create(active_value_factory, active_field: active_field, value: value)
      end
    end

    context "with include op" do
      let(:op) { ["|=", :"|=", "include", :include].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records that contain the value" do
          expect(perform_search)
            .to include(*records.select { _1.value.include?(saved_value) })
            .and exclude(*records.reject { _1.value.include?(saved_value) })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with not_include op" do
      let(:op) { ["!|=", :"!|=", "not_include", :not_include].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records that doesn't contain the value" do
          expect(perform_search)
            .to include(*records.reject { _1.value.include?(saved_value) })
            .and exclude(*records.select { _1.value.include?(saved_value) })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns all records" do
          expect(perform_search).to include(*records)
        end
      end
    end

    context "with any_gt op" do
      let(:op) { ["|>", :"|>", "any_gt", :any_gt].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records that contain an element greater than the value" do
          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem > saved_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem > saved_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with any_gteq op" do
      let(:op) { ["|>=", :"|>=", "any_gteq", :any_gteq].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records that contain an element greater than or equal to the value" do
          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem >= saved_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem >= saved_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with any_lt op" do
      let(:op) { ["|<", :"|<", "any_lt", :any_lt].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records that contain an element less than the value" do
          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem < saved_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem < saved_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with any_lteq op" do
      let(:op) { ["|<=", :"|<=", "any_lteq", :any_lteq].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records that contain an element less than or equal to the value" do
          expect(perform_search)
            .to include(*records.select { _1.value.any? { |elem| elem <= saved_value } })
            .and exclude(*records.reject { _1.value.any? { |elem| elem <= saved_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_gt op" do
      let(:op) { ["&>", :"&>", "all_gt", :all_gt].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records where all elements are greater than the value" do
          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem > saved_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem > saved_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_gteq op" do
      let(:op) { ["&>=", :"&>=", "all_gteq", :all_gteq].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records where all elements are greater than or equal to the value" do
          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem >= saved_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem >= saved_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_lt op" do
      let(:op) { ["&<", :"&<", "all_lt", :all_lt].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records where all elements are less than the value" do
          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem < saved_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem < saved_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_lteq op" do
      let(:op) { ["&<=", :"&<=", "all_lteq", :all_lteq].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records where all elements are less than or equal to the value" do
          expect(perform_search)
            .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem <= saved_value } })
            .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem <= saved_value } })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    it_behaves_like "finder_array_size"

    context "with not existing or nil op" do
      let(:op) { ["invalid", nil].sample }
      let(:value) { nil }

      it "returns nil" do
        expect(perform_search).to be_nil
      end
    end
  end
end
