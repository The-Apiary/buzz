class Category < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true
  has_and_belongs_to_many :podcasts, unique: true

  default_scope { order :name }

  def to_param
    name
  end
end
