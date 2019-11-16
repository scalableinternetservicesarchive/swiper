class AddRatingToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :rating, :float
    add_column :users, :rating_count, :integer
  end
end
