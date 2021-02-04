# frozen_string_literal: true

class CreateMomentPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :moment_photos do |t|
      t.string :description
      t.jsonb :metadata, default: {}
      t.references :account_user, foreign_key: true

      t.timestamps
    end
  end
end
