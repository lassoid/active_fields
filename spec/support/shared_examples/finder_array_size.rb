# frozen_string_literal: true

RSpec.shared_examples "finder_array_size" do
  context "with size_eq operator" do
    let(:operator) { ["#", :"#", "size_eq", :size_eq].sample }

    context "when value is a number" do
      let(:value) do
        size = records.map { _1.value.size }.uniq.sample
        [size, size.to_s].sample
      end

      it "returns only records with elements count equal to the value" do
        expect(perform_search)
          .to include(*records.select { _1.value.size == value.to_i })
          .and exclude(*records.reject { _1.value.size == value.to_i })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with size_not_eq operator" do
    let(:operator) { ["!#", :"!#", "size_not_eq", :size_not_eq].sample }

    context "when value is a number" do
      let(:value) do
        size = records.map { _1.value.size }.uniq.sample
        [size, size.to_s].sample
      end

      it "returns only records with elements count not equal to the value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.size == value.to_i })
          .and exclude(*records.select { _1.value.size == value.to_i })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns all records" do
        expect(perform_search).to include(*records)
      end
    end
  end

  context "with size_gt operator" do
    let(:operator) { ["#>", :"#>", "size_gt", :size_gt].sample }

    context "when value is a number" do
      let(:value) do
        size = (records.map { _1.value.size }.uniq - [records.map { _1.value.size }.max]).sample
        [size, size.to_s].sample
      end

      it "returns only records with elements count greater than the value" do
        expect(perform_search)
          .to include(*records.select { _1.value.size > value.to_i })
          .and exclude(*records.reject { _1.value.size > value.to_i })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with size_gteq operator" do
    let(:operator) { ["#>=", :"#>=", "size_gteq", :size_gteq].sample }

    context "when value is a number" do
      let(:value) do
        size = (records.map { _1.value.size }.uniq - [records.map { _1.value.size }.min]).sample
        [size, size.to_s].sample
      end

      it "returns only records with elements count greater than or equal to the value" do
        expect(perform_search)
          .to include(*records.select { _1.value.size >= value.to_i })
          .and exclude(*records.reject { _1.value.size >= value.to_i })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with size_lt operator" do
    let(:operator) { ["#<", :"#<", "size_lt", :size_lt].sample }

    context "when value is a number" do
      let(:value) do
        size = (records.map { _1.value.size }.uniq - [records.map { _1.value.size }.min]).sample
        [size, size.to_s].sample
      end

      it "returns only records with elements count less than the value" do
        p
        expect(perform_search)
          .to include(*records.select { _1.value.size < value.to_i })
          .and exclude(*records.reject { _1.value.size < value.to_i })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with size_lteq operator" do
    let(:operator) { ["#<=", :"#<=", "size_lteq", :size_lteq].sample }

    context "when value is a number" do
      let(:value) do
        size = (records.map { _1.value.size }.uniq - [records.map { _1.value.size }.max]).sample
        [size, size.to_s].sample
      end

      it "returns only records with elements count less than or equal to the value" do
        expect(perform_search)
          .to include(*records.select { _1.value.size <= value.to_i })
          .and exclude(*records.reject { _1.value.size <= value.to_i })
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
