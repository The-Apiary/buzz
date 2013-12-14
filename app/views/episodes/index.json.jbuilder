json.array!(@episodes) do |episode|
  json.extract! episode, :id, :title, :link_url, :description, :audio_url, :podcast_id
  json.url episode_url(episode, format: :json)
end
