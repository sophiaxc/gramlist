class CreateGramposts < ActiveRecord::Migration
  def change
    create_table :gramposts do |t|
      t.string :title
      t.string :description
      t.integer :user_id

      t.timestamps
    end
    add_index :gramposts, [:user_id, :created_at]
  end
end
