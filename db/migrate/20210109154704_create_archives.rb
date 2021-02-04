# frozen_string_literal: true

class CreateArchives < ActiveRecord::Migration[5.2]
  def change
    create_table :archives do |t|
      t.string :filename
      t.string :extension
      t.string :md5
      t.integer :size
      t.references :owner, polymorphic: true
      t.text :content

      t.timestamps
    end

    add_index :archives, :md5
    add_index :archives, :extension
    add_index :archives, :size
    add_index :archives, :filename
  end
end
