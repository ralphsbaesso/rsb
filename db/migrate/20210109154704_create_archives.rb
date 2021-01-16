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
  end
end
