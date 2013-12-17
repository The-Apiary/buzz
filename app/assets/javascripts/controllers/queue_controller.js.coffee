Buzz.QueueController = Ember.ArrayController.extend
  needs: 'index'
  queueBinding: 'controllers.index.model.queue'

  enqueue: (episode) ->
    if ! this.enqueued(episode)
      queued_episode = Buzz.QueuedEpisode.createRecord(episode)
      this.get('queue').pushObject(queued_episode)
  remove: (episode) ->
    queued_episode = Buzz.QueuedEpisode.find(episode.id)
    this.get('queue').removeObject(queued_episode)
  enqueued: (episode) ->
    this.get('queue').mapProperty('id').contains(episode.id)

  actions:
    dequeue: () ->
      this.get('queue').shiftObject()
