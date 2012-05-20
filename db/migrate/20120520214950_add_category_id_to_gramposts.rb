class AddCategoryIdToGramposts < ActiveRecord::Migration
  def change
    add_column :gramposts, :category_id, :int

  end
end
