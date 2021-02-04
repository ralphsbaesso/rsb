# frozen_string_literal: true

class CreateBAMCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :bam_categories do |t|
      t.string :name
      t.string :level
      t.string :description
      t.references :account_user, foreign_key: true

      t.timestamps
    end

    add_index :bam_categories, %i[account_user_id name], unique: true
  end
end
