class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :account_user
      t.string :rsb_module
      t.string :service
      t.string :message
      t.string :event_type
      t.string :origin
      t.string :action
      t.string :user_email
      t.boolean :important, default: false
      t.jsonb :details, default: {}

      t.timestamps
    end

    add_index :events, [:account_user_id, :rsb_module]
    add_index :events, [:account_user_id, :user_email]
    add_index :events, [:account_user_id, :important]
  end
end
