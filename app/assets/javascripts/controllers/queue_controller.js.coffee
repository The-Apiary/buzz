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
      currentEpisode = this.get 'currentEpisode'

      # Mark the episode as played
      currentEpisode.set 'is_played', true
      currentEpisode.save()

      # Remove the episode from the queue
      this.remove currentEpisode

    setCurrentPosition: (position) ->
      this.get('currentEpisode').set('current_position', position)

    setDuration: (duration) ->
      currentEpisode = this.get('currentEpisode')
      if currentEpisode.get('duration') != duration
        currentEpisode.set('duration', duration)
