# frozen_string_literal: true

class CreateAuthorsAndPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.timestamps
    end

    create_table :posts do |t|
      t.string :title
      t.string :body
      t.references :author
      t.timestamps
    end
  end
end
