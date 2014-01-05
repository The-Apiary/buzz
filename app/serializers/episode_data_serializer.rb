class EpisodeDataSerializer < ActiveModel::Serializer
  attributes :current_position, :is_played, :episode_id
end

