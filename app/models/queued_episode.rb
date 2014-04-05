class QueuedEpisode < ActiveRecord::Base
  #-- Associations
  belongs_to :episode
  belongs_to :user

  #-- Scopes
  # Queue order maintained by allocated IDs (Maybe add timestamp to record and order by that)
  default_scope { order(idx: :asc) }

  #-- Validations
  validates :user_id, presence: true
  validates :episode_id, uniqueness: true, presence: true
end
