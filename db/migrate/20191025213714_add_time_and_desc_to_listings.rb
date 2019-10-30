class AddTimeAndDescToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :start_time, :datetime
    add_column :listings, :end_time, :datetime
    add_column :listings, :description, :text
  end
end
