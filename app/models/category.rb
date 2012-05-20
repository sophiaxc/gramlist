class Category < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, length: { maximum: 140 }
  has_many :gramposts
end
