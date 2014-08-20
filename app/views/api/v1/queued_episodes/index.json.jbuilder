json.queued_episodes @queued_episodes do |queued_episode|
  json.partial! 'queued_episode', queued_episode: queued_episode
end

# Load each the episode
episodes = Episode
  .where(id: @queued_episodes.map(&:episode_id))
  .with_user_data(current_user)

json.episodes episodes do |episode|
  json.partial! 'api/v1/episodes/episode', episode: episode
end

podcasts = Podcast.where(id: episodes.map(&:podcast_id))

json.podcasts podcasts do |podcast|
  json.partial! 'api/v1/podcasts/podcast', podcast: podcast
end
