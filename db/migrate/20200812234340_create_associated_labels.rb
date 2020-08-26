class CreateAssociatedLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :associated_labels do |t|
      t.references :owner, polymorphic: true
      t.references :label, foreign_key: true

      t.timestamps
    end
  end
end
