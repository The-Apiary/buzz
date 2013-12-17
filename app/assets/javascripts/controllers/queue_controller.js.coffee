Buzz.QueueController = Ember.ArrayController.extend
  needs: 'index'
  queueBinding: 'controllers.index.model.queue'

  enqueue: (episode) ->
    this.get('queue').addObject(episode)
  remove: (episode) ->
    this.get('queue').removeObject(episode)
  enqueued: (episode) ->
    this.get('queue').mapProperty('id').contains(episode.id)

  actions:
    dequeue: () ->
      this.get('queue').shiftObject()
