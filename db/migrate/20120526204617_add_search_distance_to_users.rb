class AddSearchDistanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :search_distance, :int
  end
end
