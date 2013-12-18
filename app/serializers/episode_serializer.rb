class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :title, :link_url, :description, :audio_url, :publication_date, :podcast_id, :is_played, :current_position
end
