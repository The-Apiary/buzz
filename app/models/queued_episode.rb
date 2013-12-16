class QueuedEpisode < ActiveRecord::Base
  #-- Associations
  belongs_to :episode

  #-- Scopes
  # Queue order maintained by allocated IDs (Maybe add timestamp to record and order by that)
  default_scope { order(id: :asc) }
end
