Buzz.QueueController = Ember.ArrayController.extend
  needs: 'index'
  queueBinding: 'controllers.index.model.queue'

  currentEpisode: (->
    this.get('queue.firstObject.episode')
  ).property('queue.firstObject')

  enqueue: (episode) ->
    if ! this.enqueued(episode)
      queued_episode = Buzz.QueuedEpisode.createRecord episode: episode
      queued_episode.save()

  remove: (episode) ->
    # FIXME: How to select a QueuedEpisode with a given episode?
    # Iterate through all queued episodes (Hate)
    queued_episode = this.get('queue').find (qe) ->
      qe.get('episode') == episode
    queued_episode.deleteRecord()
    queued_episode.save()

  enqueued: (episode) ->
    if episode
      this.get('queue').mapProperty('episode').contains(episode)

  actions:
    markPlayed: () ->
      # Remove the episode from the queue
      this.remove(this.get 'currentEpisode')

    setCurrentPosition: (position) ->
      this.get('currentEpisode').set('currentPosition', position)

    setDuration: (duration) ->
      this.get('currentEpisode').set('duration', duration)
