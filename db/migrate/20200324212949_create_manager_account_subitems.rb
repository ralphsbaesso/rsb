class CreateManagerAccountSubitems < ActiveRecord::Migration[5.2]
  def change
    create_table :ma_subitems do |t|
      t.string :name
      t.string :description
      t.references :ma_item, foreign_key: true

      t.timestamps
    end
  end
end
