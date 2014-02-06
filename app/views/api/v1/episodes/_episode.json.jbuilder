json.(episode, :id, :title, :link_url, :description, :audio_url, :publication_date, :podcast_id, :duration)
json.episode_data_id episode.episode_data(current_user).try(:id)
