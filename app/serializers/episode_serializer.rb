class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :title, :link_url, :description, :audio_url, :podcast_id
end
