# frozen_string_literal: true

class AddScopeToActiveFields < ActiveRecord::Migration[7.1]
  def change
    change_table :active_fields do |t|
      t.string :scope

      t.remove_index %i[name customizable_type], unique: true
      t.add_index %i[scope customizable_type name], unique: true # TODO: Configure it to handle NULL scope too
    end
  end
end
