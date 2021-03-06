# frozen_string_literal: true

class CreateBAMAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bam_accounts do |t|
      t.string :name
      t.string :description
      t.jsonb :fields, default: []
      t.string :account_type
      t.references :account_user, foreign_key: true

      t.timestamps
    end
  end
end
