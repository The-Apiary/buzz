json.podcast do |json|
  json.partial! 'podcast', podcast: @podcast
end

json.episodes @podcast.episodes do |episode|
  json.partial! 'api/v1/episodes/episode', episode: episode
end

