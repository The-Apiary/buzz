Buzz.EpisodeController = Ember.ObjectController.extend
  needs: ['queue', 'index']
  queueBinding: 'controllers.index.model.queue'

  enqueued:  (->
    console.log 'enqueued'
    this.get('queue').contains(this.get('model'))
  ).property('@each.queue', 'queue')

  actions:
    enqueue: () ->
      this.get('queue').addObject(this.get('model'))
    remove: () ->
      this.get('queue').removeObject(this.get('model'))
