json.episodes @episodes do |episode|
  json.partial! 'episode', episode: episode
end

# Get all of the episode data's for this user and these episodes
episode_datas = EpisodeData.where episode_id: @episodes, user: current_user

json.episode_datas episode_datas do |episode_data|
  json.partial! 'api/v1/episode_datas/episode_data', episode_data: episode_data
end

# Get all of the Podcasts for these episodes
podcasts = Podcast.where id: @episodes.map(&:podcast_id).uniq
json.podcasts podcasts do |podcast|
  json.partial! 'api/v1/podcasts/podcast', podcast: podcast
end
