class AddFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :cash, :boolean, default: false
    add_column :users, :venmo, :boolean, default: false
    add_column :users, :paypal, :boolean, default: false
    add_column :users, :cashapp, :boolean, default: false
    add_column :users, :contact, :string
  end
end
