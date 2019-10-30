class CreateListings < ActiveRecord::Migration[6.0]
  def change
    create_table :listings do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.belongs_to :user, null:false, foreign_key: true
      
      t.timestamps null: false
    end

    add_index :listings, [:user_id, :name]
  end
end
