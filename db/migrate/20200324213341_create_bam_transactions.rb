class CreateBAMTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :bam_transactions do |t|
      t.string :description
      t.integer :price_cents, default: 0
      t.float :amount, default: 0.0
      t.string :origin
      t.string :status
      t.date :transaction_date
      t.date :pay_date
      t.references :bam_item
      t.references :bam_category
      t.references :bam_account, foreign_key: true
      t.references :account_user, foreign_key: true

      t.timestamps
    end
  end
end
