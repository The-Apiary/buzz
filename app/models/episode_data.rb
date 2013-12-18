class EpisodeData < ActiveRecord::Base
  belongs_to :episode

  validates :episode_id, presence: true
end
