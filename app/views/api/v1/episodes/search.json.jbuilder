json.array! @episodes do |episode|
  json.id episode.id
  json.title episode.title
  json.image_url episode.podcast.image_url
  json.podcast_title episode.podcast.title
  json.podcast_id episode.podcast.id
end
