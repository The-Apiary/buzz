class EpisodeData < ActiveRecord::Base
  belongs_to :episode
  belongs_to :user

  validates :episode_id, presence: true
end
