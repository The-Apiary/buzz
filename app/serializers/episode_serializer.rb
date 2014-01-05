class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :title, :link_url, :description, :audio_url, :publication_date, :podcast_id, :duration, :is_played, :current_position

  def episode_data
    @episode_data ||= object.episode_datas.find_by_user_id(current_user.id)
  end

  def is_played
    episode_data.try(:is_played)
  end

  def current_position
    episode_data.try(:current_position)
  end
end
