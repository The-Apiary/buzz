Buzz.ApplicationRoute = Ember.Route.extend
  needs: 'queue'
  actions:
    enqueue: (episode) ->
      console.log episode
      queued_episode = Buzz.QueuedEpisode.createRecord episode: episode
      queued_episode.save()
