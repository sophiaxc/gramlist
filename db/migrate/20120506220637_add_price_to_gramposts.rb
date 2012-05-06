class AddPriceToGramposts < ActiveRecord::Migration
  def change
    add_column :gramposts, :price, :int
  end
end
