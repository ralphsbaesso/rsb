class CreateBAMTransactionsLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :bam_transactions_labels do |t|
      t.references :label, foreign_key: true
      t.references :bam_transaction, foreign_key: true
    end
  end
end
