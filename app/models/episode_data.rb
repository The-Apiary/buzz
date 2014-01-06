class EpisodeData < ActiveRecord::Base
  belongs_to :episode
  belongs_to :user

  validates :episode_id, presence: true
  validates :episode_id, uniqueness: { scope: :user_id }

  def special_id
    "#{self.user_id}_#{self.episode_id}"
  end
end
