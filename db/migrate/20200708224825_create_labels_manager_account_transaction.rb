class CreateLabelsManagerAccountTransaction < ActiveRecord::Migration[5.2]
  def change
    create_table :labels_ma_transactions do |t|
      t.references :label, foreign_key: true
      t.references :ma_transaction, foreign_key: true
    end
  end
end
