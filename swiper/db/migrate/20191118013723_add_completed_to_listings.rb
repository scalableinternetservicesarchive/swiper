class AddCompletedToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :completed, :boolean, :default => false
  end
end
