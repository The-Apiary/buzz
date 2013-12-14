class Podcast < ActiveRecord::Base
  validates :feed_url, uniqueness: true
  validates :feed_url, presence: true
end
