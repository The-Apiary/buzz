json.queued_episode do |json|
  json.partial! 'queued_episode', queued_episode: @queued_episode
end
