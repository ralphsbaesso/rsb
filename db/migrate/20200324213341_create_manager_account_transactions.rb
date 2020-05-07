class CreateManagerAccountTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :ma_transactions do |t|
      t.string :description
      t.integer :price_cents, default: 0
      t.float :amount, default: 0.0
      t.string :origin
      t.string :status
      t.date :transaction_date
      t.date :pay_date
      t.references :ma_item
      t.references :ma_subitem
      t.references :ma_account, foreign_key: true
      t.references :account_user, foreign_key: true

      t.timestamps
    end
  end
end
