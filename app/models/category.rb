class Category < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true
  has_and_belongs_to_many :podcasts
end
