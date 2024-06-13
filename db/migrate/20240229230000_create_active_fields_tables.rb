# frozen_string_literal: true

class CreateActiveFieldsTables < ActiveRecord::Migration[6.0]
  def change
    create_table :active_fields do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.string :customizable_type, null: false
      t.jsonb :default_value
      t.jsonb :options, null: false, default: {}

      t.timestamps

      t.index %i[name customizable_type], unique: true
      t.index :customizable_type
    end

    create_table :active_fields_values do |t|
      t.references :customizable, polymorphic: true, null: false, index: false
      t.references :active_field,
        null: false,
        foreign_key: { to_table: :active_fields, name: "active_fields_values_active_field_id_fk" }
      t.jsonb :value

      t.timestamps

      t.index %i[customizable_type customizable_id active_field_id],
        unique: true,
        name: "index_active_fields_values_on_customizable_and_field"
    end
  end
end
