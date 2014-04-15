json.(episode, :id, :title, :link_url, :description, :audio_url, :publication_date, :podcast_id, :duration)
json.is_played episode.is_played(current_user)
json.current_position episode.current_position(current_user)
