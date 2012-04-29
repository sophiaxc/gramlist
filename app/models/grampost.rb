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
end
