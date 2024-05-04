# frozen_string_literal: true

# RSpec.shared_examples "customizable" do |factory:|
#   context "associations" do
#     it { is_expected.to have_many(:custom_fields).autosave(false).dependent(:destroy) }
#   end
#
#   context "validations" do
#     context "validates associated custom fields" do
#       let_it_be(:definition, refind: true) do
#         custom_field_definition_sample_record(:create, customizable_type: described_class.name)
#       end
#       let(:value) { build(custom_field_factory(definition.class.name)).value }
#       let(:errors) { Set.new(%i[invalid blank]) }
#
#       before do
#         validator_double = instance_double(definition.field_validator_class)
#         allow(definition).to receive(:field_validator).and_return(validator_double)
#         allow(validator_double).to receive(:validate).with(value).and_return(false)
#         allow(validator_double).to receive(:errors).and_return(errors)
#       end
#
#       context "new record" do
#         let(:record) do
#           build(factory, custom_fields_attributes: { definition.name => value })
#         end
#
#         it "validates custom fields" do
#           record.valid?
#
#           custom_field = record.custom_fields.find { |custom_field| custom_field.definition_id == definition.id }
#           expect(record.errors.of_kind?(:custom_fields, :invalid)).to be(true)
#           errors.each do |error|
#             expect(custom_field.errors.of_kind?(:value, error)).to be(true)
#           end
#         end
#       end
#
#       context "persisted record" do
#         let_it_be(:record, refind: true) { create(factory) }
#
#         before do
#           record.custom_fields_attributes = { definition.name => value }
#         end
#
#         it "validates custom fields" do
#           record.valid?
#
#           custom_field = record.custom_fields.find { |custom_field| custom_field.definition_id == definition.id }
#           expect(record.errors.of_kind?(:custom_fields, :invalid)).to be(true)
#           errors.each do |error|
#             expect(custom_field.errors.of_kind?(:value, error)).to be(true)
#           end
#         end
#       end
#     end
#   end
#
#   context "callbacks" do
#     let_it_be(:definition, refind: true) do
#       custom_field_definition_sample_record(:create, customizable_type: described_class.name)
#     end
#
#     describe "before_validation #initialize_custom_fields" do
#       context "new record" do
#         let(:record) { build(factory, custom_fields_attributes: custom_fields_attributes) }
#
#         context "with nil custom_fields_attributes" do
#           let(:custom_fields_attributes) { nil }
#
#           it "builds custom fields with defaults" do
#             expect do
#               record.valid?
#             end.to change { record.custom_fields.size }.by(1)
#
#             field = record.custom_fields.find { |custom_field| custom_field.definition_id == definition.id }
#             caster = definition.field_caster
#             expect(field.value).to eq(caster.deserialize(caster.serialize(definition.default)))
#           end
#         end
#
#         context "with invalid custom_fields_attributes" do
#           let(:custom_fields_attributes) { random_string }
#
#           it "builds custom fields with defaults" do
#             expect do
#               record.valid?
#             end.to change { record.custom_fields.size }.by(1)
#
#             field = record.custom_fields.find { |custom_field| custom_field.definition_id == definition.id }
#             caster = definition.field_caster
#             expect(field.value).to eq(caster.deserialize(caster.serialize(definition.default)))
#           end
#         end
#
#         context "with string custom_fields_attributes keys" do
#           let(:custom_fields_attributes) do
#             {
#               definition.name => build(custom_field_factory(definition.class.name)).value,
#               "non existing definition name" => "doesn't matter",
#             }
#           end
#
#           it "builds custom fields with provided values" do
#             expect do
#               record.valid?
#             end.to change { record.custom_fields.size }.by(1)
#
#             field = record.custom_fields.find { |custom_field| custom_field.definition_id == definition.id }
#             caster = definition.field_caster
#             expect(field.value).to eq(
#               caster.deserialize(caster.serialize(custom_fields_attributes[definition.name])),
#             )
#           end
#         end
#
#         context "with symbol custom_fields_attributes keys" do
#           let(:custom_fields_attributes) do
#             {
#               definition.name.to_sym => build(custom_field_factory(definition.class.name)).value,
#               "non existing definition name" => "doesn't matter",
#             }
#           end
#
#           it "builds custom fields with provided values" do
#             expect do
#               record.valid?
#             end.to change { record.custom_fields.size }.by(1)
#
#             field = record.custom_fields.find { |custom_field| custom_field.definition_id == definition.id }
#             caster = definition.field_caster
#             expect(field.value).to eq(
#               caster.deserialize(caster.serialize(custom_fields_attributes[definition.name.to_sym])),
#             )
#           end
#         end
#       end
#
#       context "persisted record" do
#         let_it_be(:record, refind: true) { create(factory) }
#
#         before do
#           record.custom_fields_attributes = custom_fields_attributes
#         end
#
#         context "with nil custom_fields_attributes" do
#           let(:custom_fields_attributes) { nil }
#
#           it "doesn't change custom fields values" do
#             expect do
#               record.valid?
#             end.to not_change { record.custom_fields.find { _1.definition_id == definition.id }.value }
#           end
#         end
#
#         context "with invalid custom_fields_attributes" do
#           let(:custom_fields_attributes) { random_string }
#
#           it "doesn't change custom fields values" do
#             expect do
#               record.valid?
#             end.to not_change { record.custom_fields.find { _1.definition_id == definition.id }.value }
#           end
#         end
#
#         context "with string custom_fields_attributes keys" do
#           let(:custom_fields_attributes) do
#             {
#               definition.name => build(custom_field_factory(definition.class.name)).value,
#               "non existing definition name" => "doesn't matter",
#             }
#           end
#
#           it "changes custom fields for provided values only" do
#             caster = definition.field_caster
#             expect do
#               record.valid?
#             end.to change { record.custom_fields.find { _1.definition_id == definition.id }.value }.to(
#               caster.deserialize(caster.serialize(custom_fields_attributes[definition.name])),
#             )
#           end
#         end
#
#         context "with symbol custom_fields_attributes keys" do
#           let(:custom_fields_attributes) do
#             {
#               definition.name.to_sym => build(custom_field_factory(definition.class.name)).value,
#               "non existing definition name" => "doesn't matter",
#             }
#           end
#
#           it "changes custom fields for provided values only" do
#             caster = definition.field_caster
#             expect do
#               record.valid?
#             end.to change { record.custom_fields.find { _1.definition_id == definition.id }.value }.to(
#               caster.deserialize(caster.serialize(custom_fields_attributes[definition.name.to_sym])),
#             )
#           end
#         end
#       end
#     end
#
#     describe "after_save #save_changed_custom_fields" do
#       let_it_be(:other_definition, refind: true) do
#         custom_field_definition_sample_record(:create, customizable_type: described_class.name)
#       end
#
#       context "new record" do
#         let(:record) { build(factory) }
#
#         it "saves all custom fields" do
#           expect do
#             record.save!
#             record.reload
#           end.to change { record.custom_fields.size }.by(2)
#         end
#       end
#
#       context "persisted record" do
#         let_it_be(:record, refind: true) { create(factory) }
#         let(:custom_fields_attributes) do
#           {
#             definition.name => build(custom_field_factory(definition.class.name)).value,
#             "non existing definition name" => "doesn't matter",
#           }
#         end
#
#         before do
#           record.custom_fields_attributes = custom_fields_attributes
#         end
#
#         it "saves only changed custom fields" do
#           caster = definition.field_caster
#           expect do
#             record.save!
#             record.reload
#           end.to change { record.custom_fields.find { _1.definition_id == definition.id }.value }.to(
#             caster.deserialize(caster.serialize(custom_fields_attributes[definition.name])),
#           ).and not_change { record.custom_fields.find { _1.definition_id == other_definition.id }.value }
#         end
#       end
#     end
#   end
#
#   context "methods" do
#     describe "##custom_field_definitions" do
#       before_all do
#         @records =
#           custom_field_definition_suitable_model_names.map do |cfd_model_name|
#             create(
#               custom_field_definition_factory(cfd_model_name),
#               customizable_type: described_class.name,
#             )
#           end
#       end
#
#       let(:records) { @records }
#
#       it "returns available custom fields definitions for model" do
#         expect(described_class.custom_field_definitions.to_a).to include(*records)
#       end
#     end
#   end
# end
