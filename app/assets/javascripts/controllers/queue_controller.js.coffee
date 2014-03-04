Buzz.QueueController = Ember.ArrayController.extend

  queued_episodes: (->
    Buzz.QueuedEpisode.find()
  ).property('Buzz.QueuedEpisode')

  current_episode: (->
    console.log this.get('queued_episodes.length')
    this.get('queued_episodes.firstObject.episode')
  ).property('queued_episodes', 'queued_episodes.length')

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
