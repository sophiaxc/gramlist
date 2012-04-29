# == Schema Information
#
# Table name: gramposts
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Grampost < ActiveRecord::Base
  attr_accessible :title, :description
  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }

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
