# == Schema Information
#
# Table name: gramposts
#
#  id                 :integer         not null, primary key
#  title              :string(255)
#  description        :string(255)
#  user_id            :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  price              :integer
#  category_id        :integer
#

# Medium image: width = 300
# Large image: width = 400

class Grampost < ActiveRecord::Base
  attr_accessible :title, :description, :photo, :price, :category_id
  belongs_to :user
  belongs_to :category
  has_attached_file :photo, {
    :storage => :s3,
    :bucket => ENV['S3_BUCKET_NAME'],
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    },
    :styles => {
      :large => "400x",
      :thumb => "300x",
    },
    :path => "grampost/photo/:id/:style/:hash.:extension",
    :hash_secret => ENV['AVATAR_HASH'],
    :default_url => "/assets/no_photo_:style.png"
  }


  validates_attachment :photo, presence: true,
    :content_type => {
        :content_type => ["image/jpg", "image/x-png", "image/jpeg", "image/png"] },
        :size => { :in => 0..4.megabytes }
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :price, presence: true, :numericality => { :only_integer => true,
                                                       :greater_than_or_equal_to => 0 }
  validates :title, presence: true, length: { maximum: 140 }
  validates :description, length: { maximum: 300 }

  default_scope order: 'gramposts.created_at DESC'
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private

    # Returns an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      if user.followed_user_ids.empty?
        where("user_id = ?", user)
      else
        followed_user_ids = %(SELECT followed_id FROM relationships
                              WHERE follower_id = :user_id)
        where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
               { user_id: user })
      end
    end
end
