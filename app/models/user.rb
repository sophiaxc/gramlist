# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  email               :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  password_digest     :string(255)
#  remember_token      :string(255)
#  admin               :boolean         default(FALSE)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  zipcode             :string(255)
#  latitude            :float
#  longitude           :float
#  city                :string(255)
#  state               :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :avatar, :name, :email, :password,
                  :password_confirmation, :zipcode

  # Geocoding a user
  # TODO(sophia): This is hella ghetto. Should refactor location data
  # from user and grampost into single model.
  geocoded_by :zipcode
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city = geo.city
      obj.state = geo.state
    end
  end
  after_validation :reverse_geocode

  has_secure_password
  has_attached_file :avatar, {
    :storage => :s3,
    :bucket => ENV['S3_BUCKET_NAME'],
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    },
    :styles => {
      :medium => "300x300#",
      :thumb => "100x100#",
      :mini => "50x50#"
    },
    :path => "user/avatars/:id/:style/:hash.:extension",
    :hash_secret => ENV['AVATAR_HASH'],
    :default_url => "/assets/no_avatar_:style.png"
  }

  has_many :gramposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates_attachment :avatar, :content_type => {
    :content_type => ["image/jpg", "image/x-png", "image/jpeg", "image/png"] },
                                :size => { :in => 0..2.megabytes }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  VALID_ZIPCODE_REGEX = /^\d{5}(-\d{4})?$/
  validates :zipcode, presence: true,
                      format: { with: VALID_ZIPCODE_REGEX,
                                message: "should be in the form 12345 or 12345-1234"}

  def feed
    Grampost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
