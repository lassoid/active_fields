# frozen_string_literal: true

RSpec.describe ActiveFields::Field::EnumArray do
  factory = :enum_array_active_field # rubocop:disable RSpec/LeakyLocalVariable

  it_behaves_like "active_field",
    factory: factory,
    available_traits: %i[with_min_size with_max_size]

  it_behaves_like "store_attribute_integer", :min_size, :options, described_class
  it_behaves_like "store_attribute_integer", :max_size, :options, described_class
  it_behaves_like "store_attribute_text_array", :allowed_values, :options, described_class

  context "validations" do
    it_behaves_like "field_sizes_validate", factory: factory

    describe "#validate_allowed_values" do
      let(:record) { build(factory, allowed_values: allowed_values) }

      context "when allowed_values is nil" do
        let(:allowed_values) { nil }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:allowed_values, :blank)).not_to be_empty
        end
      end

      context "when allowed_values is an empty array" do
        let(:allowed_values) { [] }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:allowed_values, :blank)).not_to be_empty
        end
      end

      context "when allowed_values contains nil" do
        let(:allowed_values) { [random_string, nil] }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:allowed_values, :invalid)).not_to be_empty
        end
      end

      context "when allowed_values contains a blank string" do
        let(:allowed_values) { [random_string, "   "] }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:allowed_values, :invalid)).not_to be_empty
        end
      end

      context "when allowed_values is an array of strings" do
        let(:allowed_values) { [random_string, random_string] }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:allowed_values)).to be_empty
        end
      end
    end
  end

  context "callbacks" do
    describe "after_initialize #set_defaults" do
      let(:record) { described_class.new(allowed_values: allowed_values) }

      context "when allowed_values is nil" do
        let(:allowed_values) { nil }

        it "sets empty array" do
          expect(record.allowed_values).to eq([])
        end
      end

      context "when allowed_values is not nil" do
        let(:allowed_values) { [random_string] }

        it "doesn't change column" do
          expect(record.allowed_values).to eq(allowed_values)
        end
      end
    end
  end
end
