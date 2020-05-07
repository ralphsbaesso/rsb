class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :account_user, foreign_key: true
      t.string :rsb_module
      t.string :service
      t.string :message
      t.string :event_type
      t.string :origin
      t.string :action
      t.boolean :important, default: false
      t.jsonb :details, default: {}

      t.timestamps
    end
  end
end
