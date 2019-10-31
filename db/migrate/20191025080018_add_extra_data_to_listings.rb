class AddExtraDataToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :price, :float
    add_column :listings, :location, :integer

    # we have to make the columns before we can make them not null
    change_column :listings, :price, :float, null: false
    change_column :listings, :location, :integer, null: false
    
    add_column :listings, :amount, :integer, default: 1
    add_column :listings, :state, :integer, default: 0

    remove_column :listings, :name
    remove_column :listings, :description

    add_index :listings, [:price]
  end
end
