Buzz.QueueController = Ember.ArrayController.extend
  needs: 'index'
  queueBinding: 'controllers.index.model.queue'

  actions:
    dequeue: () ->
      this.get('queue').shiftObject()
    enqueue: (episode) ->
      this.get('queue').addObject(episode)
    remove: (episode) ->
      this.get('queue').removeObject(episode)
