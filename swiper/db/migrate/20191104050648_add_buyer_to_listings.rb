class AddBuyerToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :buyer, :integer
  end
end
