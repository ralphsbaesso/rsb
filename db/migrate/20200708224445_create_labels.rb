class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.string :name
      t.string :original_name
      t.string :app
      t.string :color
      t.string :background_color
      t.references :account_user, foreign_key: true

      t.timestamps
    end

    add_index :labels, [:account_user_id, :app, :name]
  end
end

