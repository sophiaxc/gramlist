class AddAttachmentPhotoToGramposts < ActiveRecord::Migration
  def self.up
    add_column :gramposts, :photo_file_name, :string
    add_column :gramposts, :photo_content_type, :string
    add_column :gramposts, :photo_file_size, :integer
    add_column :gramposts, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :gramposts, :photo_file_name
    remove_column :gramposts, :photo_content_type
    remove_column :gramposts, :photo_file_size
    remove_column :gramposts, :photo_updated_at
  end
end
