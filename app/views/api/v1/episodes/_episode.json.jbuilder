json.(episode, :id, :title, :link_url, :description, :audio_url, :publication_date, :podcast_id, :duration, :episode_type)
json.ed_is_played episode.is_played(current_user)
json.ed_current_position episode.current_position(current_user)
