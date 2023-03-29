# frozen_string_literal: true

class CreateLeveretAuthTables < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.string :uid, null: false
      t.string :provider, null: false
      t.references :user, null: false
      t.timestamps
    end

    add_index :identities, %i[uid provider]

    # Uncomment below to ensure a valid reference to the user's table
    add_foreign_key :identities, :users, column: :user_id
  end
end
