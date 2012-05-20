class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    # Now populate category list with default categories
    Category.create!( name: "Appliances" )
    Category.create!( name: "Art" )
    Category.create!( name: "Bikes" )
    Category.create!( name: "Books" )
    Category.create!( name: "Clothing" )
    Category.create!( name: "Electronics" )
    Category.create!( name: "Furniture" )
    Category.create!( name: "Jewelry" )
    Category.create!( name: "Other" )
    Category.create!( name: "Toys" )
    Category.create!( name: "Vehicles" )
  end
end
