json.episodes @episodes do |episode|
  json.partial! 'episode', episode: episode
end

# Get all of the Podcasts for these episodes
podcasts = Podcast.where id: @episodes.map(&:podcast_id).uniq
json.podcasts podcasts do |podcast|
  json.partial! 'api/v1/podcasts/podcast', podcast: podcast
end

json.meta do
  json.limit @limit
  json.offset @offset
  json.total @total
end
