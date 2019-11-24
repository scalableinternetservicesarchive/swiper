class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.float  :rating, null: false, default: 0.0
      t.integer :rating_count, null: false, default: 0
    end

    add_index :users, :email
    add_index :users, :remember_token
  end
end
