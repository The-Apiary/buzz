Buzz.QueueController = Ember.ArrayController.extend
  queued_episodes: (-> Buzz.QueuedEpisode.find()).property()

  enqueued: (episode) ->
    this.get('queued_episodes').mapProperty('episode').contains(episode)

  dequeue: (episode) ->
    queued_episode = this.get('queued_episodes').find (qe) ->
      qe.get('episode') == episode

    queued_episode.deleteRecord()
    queued_episode.save()

  enqueue: (episode) ->
    queued_episode = Buzz.QueuedEpisode.createRecord episode: episode
    queued_episode.save()
