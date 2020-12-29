class CreateBAMTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :bam_transactions do |t|
      t.integer :price_cents, default: 0
      t.float :amount, default: 0.0

      t.string :origin
      t.string :status
      t.string :description

      t.text :annotation
      t.date :transacted_at
      t.date :paid_at

      t.boolean :ignore, :boolean, default: false

      t.references :bam_item
      t.references :bam_category
      t.references :bam_account, foreign_key: true
      t.references :account_user, foreign_key: true

      t.timestamps
    end
  end
end
