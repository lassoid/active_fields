# frozen_string_literal: true

class CreatePostsAndComments < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :body
      t.timestamps
    end

    create_table :comments do |t|
      t.references :post
      t.string :body
      t.timestamps
    end
  end
end
