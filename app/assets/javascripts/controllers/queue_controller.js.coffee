Buzz.QueueController = Ember.ArrayController.extend
  needs: 'index'
  queueBinding: 'controllers.index.model.queue'

  currentEpisode: ->
    this.get('queue.firstObject')

  enqueue: (episode) ->
    if ! this.enqueued(episode)
      queued_episode = Buzz.QueuedEpisode.createRecordFromEpisode episode
      queued_episode.save()

  remove: (episode) ->
    queued_episode = Buzz.QueuedEpisode.find(episode.id)
    queued_episode.deleteRecord()
    queued_episode.get('store').commit()

  enqueued: (episode) ->
    this.get('queue').mapProperty('id').contains(episode.id)

  actions:
    markPlayed: () ->
      queued_episode = this.currentEpisode()
      queued_episode.deleteRecord()
      queued_episode.get('store').commit()

    setCurrentPosition: (position) ->
      this.currentEpisode().set('currentPosition', position)

    setDuration: (duration) ->
      this.currentEpisode().set('duration', duration)
