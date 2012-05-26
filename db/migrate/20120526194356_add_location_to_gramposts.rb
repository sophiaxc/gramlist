class AddLocationToGramposts < ActiveRecord::Migration
  def change
    add_column :gramposts, :zipcode, :string
    add_column :gramposts, :latitude, :float
    add_column :gramposts, :longitude, :float
    add_column :gramposts, :city, :string
    add_column :gramposts, :state, :string
  end
end
