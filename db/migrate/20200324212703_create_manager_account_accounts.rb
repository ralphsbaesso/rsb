class CreateManagerAccountAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :ma_accounts do |t|
      t.string :name
      t.string :description
      t.references :account_user, foreign_key: true

      t.timestamps
    end
  end
end