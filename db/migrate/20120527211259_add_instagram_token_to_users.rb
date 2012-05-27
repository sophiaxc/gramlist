class AddInstagramTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instagram_token, :string
  end
end
