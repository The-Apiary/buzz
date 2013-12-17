Buzz.QueuedEpisode = Buzz.Episode.extend()

Buzz.QueuedEpisode.reopenClass
  # TODO: Can this be less explicit, I just want to create a new queued_episode from an episode
  createRecordFromEpisode: (episode) ->
      Buzz.QueuedEpisode.createRecord
        title: episode.get 'title'
        link_url: episode.get 'link_url'
        description: episode.get 'description'
        audio_url: episode.get 'audio_url'
        title: episode.get 'title'
        podcast: episode.get 'podcast'
        id: episode.get 'id'
