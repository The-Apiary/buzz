class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :title, :link_url, :description, :audio_url, :publication_date, :podcast_id, :duration, :episode_data_id

  def episode_data
    @episode_data ||= object.episode_datas.find_by_user_id(current_user.id)
  end

  def episode_data_id
    episode_data.try(:id)
  end
end
