json.queued_episodes @queued_episodes do |queued_episode|
  json.partial! 'queued_episode', queued_episode: queued_episode
end

# Load each the episode
episodes = Episode.where id: @queued_episodes.map(&:episode_id)

json.episodes episodes do |episode|
  json.partial! 'api/v1/episodes/episode', episode: episode
end

# Get all of the episode data's for this user and these episodes
episode_datas = EpisodeData.where episode_id: episodes, user: current_user

json.episode_datas episode_datas do |episode_data|
  json.partial! 'api/v1/episode_datas/episode_data', episode_data: episode_data
end

podcasts = Podcast.where id: episodes.map(&:podcast_id)

json.podcasts podcasts do |podcast|
  json.partial! 'api/v1/podcasts/podcast', podcast: podcast
end
