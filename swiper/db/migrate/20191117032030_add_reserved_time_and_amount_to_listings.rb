class AddReservedTimeAndAmountToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :reserved_time, :datetime
    add_column :listings, :reserved_amount, :integer
  end
end
